Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784C4565A5C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiGDPvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiGDPvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:51:51 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7026E5
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 08:51:50 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-fe023ab520so13707841fac.10
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 08:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=b/ZxYM0BCiPHkjbWAV8PGdJWqx6f1QoX0PAokWq7IvQ=;
        b=e1ym/QQJ9ziCfx0YKZy/mrB37V6VAeAZ+3TA9ijgjURV9dDNW5fA7MGEFmiWsY/PGT
         F/Jt8LK2Rof8W1RlgWCJt3NbdVA69ZvbaYvpReb8vBvDYry1SOJHzMQRvQO0ddmSc6aO
         VqE3NNmb3TUskk+BXt0F8VD9INeU6SWzS0kJIZoluPxvtLAoO7jxKxWbro/ms7WYVPK3
         HdKXflkkppsSLRLLSLBbXUSoeUEvNyl+bZn1G3DiwYLpHnBWAzh7PydJjsusA4lLtYQP
         O5G0uDVVL1qvBJBJ79FsXYopVQAf6GADqv1f+r/rD3H9cGUi6RSLkLaJNlMSKdBbCJQE
         VBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=b/ZxYM0BCiPHkjbWAV8PGdJWqx6f1QoX0PAokWq7IvQ=;
        b=3lLlPJLH3tKJU4TlZgEtBA2hHUchmq9YwhPrMzNdGtGR+tSOff61kgrBykbaJszjRp
         9Lzm0fUA/wu6lpGpd2bzZaTAGqrST//v4upOEmt0r6crmHOE64hO+hF9VpKJFNAObXS8
         V/+ZUQilvT7MO+Ndb0VKJV8mkAyCInd/nzFkMyhpss4nZZDuo9brWPlbSJgSzKQYVepW
         xe8RWWoA4v9i7KGe1u9f3uKuw+VK5/cPyEtBpE9ztAz4qRaN02374+WQhYT9+EM6Bgl+
         bvwFLz80Sff+SvLjCOh7DJm7XGglM66I7sc8DwClGA8b2AIfdRNbw8kPxrdAZU6jK4Tp
         s1nQ==
X-Gm-Message-State: AJIora9fETu/x7NdTuDk4ugCFEU8BkkaUyLtX7AShrTl3IXy4EHdlJ3M
        65UTnBqx7y/xiEna718rj6gfOrmSrXajk57MonQwvA==
X-Google-Smtp-Source: AGRyM1tVZQC3M8dOf/4UVM6nmOaAvAiWXDpGqZ/+hY0hCRzu24Rgu+F2Htwx5WPjPnGIV2CYzqn7ruhSFqDLz60+9iA=
X-Received: by 2002:a05:6870:8892:b0:101:9d4f:4aa5 with SMTP id
 m18-20020a056870889200b001019d4f4aa5mr17793312oam.106.1656949910375; Mon, 04
 Jul 2022 08:51:50 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 4 Jul 2022 11:51:39 -0400
Message-ID: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
Subject: Report: iproute2 build broken?
To:     Petr Machata <petrm@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have to admit i am being lazy here digging into the
root cause but normally iproute2 should just build
standalone regardless especially when it is a stable
version:

$ cat include/version.h
static const char version[] =3D "5.18.0";

$make
..
....
.....
  CC       iplink_bond.o
iplink_bond.c:935:10: error: initializer element is not constant
  .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
          ^
iplink_bond.c:935:10: note: (near initialization for
=E2=80=98ipstats_stat_desc_xstats_bond_lacp.desc=E2=80=99)
iplink_bond.c:957:10: error: initializer element is not constant
  .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
          ^
iplink_bond.c:957:10: note: (near initialization for
=E2=80=98ipstats_stat_desc_xstats_slave_bond_lacp.desc=E2=80=99)
../config.mk:40: recipe for target 'iplink_bond.o' failed
make[1]: *** [iplink_bond.o] Error 1
Makefile:77: recipe for target 'all' failed
make: *** [all] Error 2

There's more if you fix that one given a whole lot
of dependencies

cheers,
jamal
