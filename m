Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8D34EB862
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbiC3Ck4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242054AbiC3Cky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:40:54 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80BAA94C4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 19:39:09 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id u15-20020a92da8f000000b002c863d2f21dso10202619iln.15
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 19:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MGY4ked8FrP/RDpFhZIyerD1Rqnm8bxFvDVSgecXTM0=;
        b=yVdvyAEVlEjEhMm/RaxIcDeV6Kaf2req+sW37BKQ4oHY5UXTTW/ettJYmpLjW1YoLK
         3lir6jASy4TMofr4ioBPOaUiNebolZdeBDkTl8Rtnfn7GwaVSGoL3EJ6lfSsepUybwCN
         3msJkQOF7c8LUIwfzwwS0FGPcP+BOla38aLlS3gmRo6rAdNLe4J4johBYqfQomhzWye7
         20jzE4FxYMojSTi0Bgk5Sn0cq+wrSzGm/INZTwVmnawHOJt4JggU6jSqc64R++Qvxzb8
         WJmj/jfiBLHTwwuWJZgyGRvTCN3usuk8Qcr4wVcwYurrRHlYveuxwhQ73cZfc4272t76
         Txfw==
X-Gm-Message-State: AOAM530EOsuESM1ID4O+vF5W88MzTWNGO/xSSAGwnZzi287kPWbPyIfR
        gC73n79ysjndlcY3jGaTSbCrni/XPcrwbQVhZINMHHWGIPSq
X-Google-Smtp-Source: ABdhPJyUEaP285XNxj6Cem8fvK5XyzQTUM+P5p8p/WLmotpZHrPuhjFTZSz2WN85+3r0Rj9bcw/GMtIqbVBAaoLLA24d9KdGtmei
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22c7:b0:323:9349:fc42 with SMTP id
 j7-20020a05663822c700b003239349fc42mr1407731jat.312.1648607949128; Tue, 29
 Mar 2022 19:39:09 -0700 (PDT)
Date:   Tue, 29 Mar 2022 19:39:09 -0700
In-Reply-To: <PH0PR11MB5880D33225C1E8A684BCFF64DA1F9@PH0PR11MB5880.namprd11.prod.outlook.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002e8c1805db6673e2@google.com>
Subject: Re: [syzbot] memory leak in gs_usb_probe
From:   syzbot <syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, pabeni@redhat.com, pfink@christ-es.de,
        qiang1.zhang@intel.com, syzkaller-bugs@googlegroups.com,
        wg@grandegger.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/net/can/usb/gs_usb.c
patch: **** unexpected end of file in patch



Tested on:

commit:         c2528a0c Add linux-next specific files for 20220329
git tree:       linux-next
dashboard link: https://syzkaller.appspot.com/bug?extid=4d0ae90a195b269f102d
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=166a33ab700000

