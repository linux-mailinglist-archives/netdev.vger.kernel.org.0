Return-Path: <netdev+bounces-5076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D8470F997
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D72B281411
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152CE18C3D;
	Wed, 24 May 2023 15:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07058182D1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:02:38 +0000 (UTC)
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A0F5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:02:36 -0700 (PDT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-19a60c9ddecso103027fac.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684940556; x=1687532556;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkTt7pUa2ZVNwy/OEsrIK++2IUTMhQoejHkdP2b+d60=;
        b=d9EsuZAIbHcVeQMO64hait24iTQidblDhiaTgBUcDoMzwEnVU3UX+B3qhg6L/maUSk
         VFbzMHY72p1lu+7y4w2ZUKM9wX6Lhi1Ho/2xcxQlGl9kePyGide8n4jx0GwxsQx47U7H
         lkpPmaTVP1OrW7Lq8TS5v+LaBmBn1r4IOt5m9o3c0bd8OxG9iTtwGyuTEekBELne2RsD
         iBU6shl1ySD2ZZGRMUjBOsIWHZQPILG+jpBNf+DcXWHwHE8SHU124ceZVQTljyJAssD5
         aaBoG/IYuXtIx08OckS6MKhA5HUQclwybeMJbSXZKWSQ6lLW8Dltb7JMG+EabH9aKwZI
         uZdA==
X-Gm-Message-State: AC+VfDyGue+nX0MRuTOwy4EYVqj6+Z9z3ihol2aLnwAym6igHoNpLSqQ
	wziQT9gTLh2071FBSNsFEdqDfX4OdYOk/+7NwNWxP51Q5oAq
X-Google-Smtp-Source: ACHHUZ68LW5oC+fz0KsQ4ML8Xri9cf5VSXK28NaSo2LBUG1xrm2H3fwQhE8/IZiAwX6ePa/8pxEbtZBym2jxxMNYhHWCjVM5PCCM
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6871:6b9f:b0:196:bc94:bff4 with SMTP id
 zh31-20020a0568716b9f00b00196bc94bff4mr8946oab.10.1684940556301; Wed, 24 May
 2023 08:02:36 -0700 (PDT)
Date: Wed, 24 May 2023 08:02:36 -0700
In-Reply-To: <f309f841-3997-93cf-3f30-fa2b06560fc0@mojatatu.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000537fad05fc71cbb4@google.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in mini_qdisc_pair_swap
From: syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com, 
	jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, pctammela@mojatatu.com, 
	syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to checkout kernel repo git://gitlab.com/tammela/net.git/peilin-patches: failed to run ["git" "fetch" "--force" "71d757925c19d8f23c660d1e07af98f28b9c6977" "peilin-patches"]: exit status 128
fatal: read error: Connection reset by peer



Tested on:

commit:         [unknown 
git tree:       git://gitlab.com/tammela/net.git peilin-patches
dashboard link: https://syzkaller.appspot.com/bug?extid=b53a9c0d1ea4ad62da8b
compiler:       

Note: no patches were applied.

