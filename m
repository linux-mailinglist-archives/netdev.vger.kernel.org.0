Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159274EB810
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiC3CAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbiC3CAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:00:04 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05381C4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:58:19 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u18-20020a5d8712000000b0064c7a7c497aso4737217iom.18
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IseIOXkjbiVc9FdIOxRiy+s/BeCwVlVVfBMa+vQ5dYY=;
        b=LCN+tXaytOxB5BoAZgyIqHICsGxLxzDikxdiwGGHoqIdhwHPgWtebqWrctEAeG0NNZ
         cHGIBhhzL1vbt/r+Kg9EnJprLwq8y7MpmCSR/J3TZmwZ1fMg60zYLK4sRF+vzmuGjrwH
         BAvYAWyFZ90i+0FbUspz9kOgs+fR9MqB5MUFoqm6YQKoAHL50t9C6G4kOQ+ADLNtT1Le
         Q2W1rfRuEbcnBxdHaKQipaXMniUh8D3jkkb9D461d3Xf02x61kVel02vGjhM1wlatVgv
         olunZSdY6g6a/cQh/TlNOd9sb3UW22BGgsalVai7YvmW+w52ZZ5qpblFGaHhhCTX16Sj
         Vsng==
X-Gm-Message-State: AOAM533xIe4zJmWCnzjAbIGitHNQj5FjF+9wmTMnk60BHhJhaDFzUsiz
        iQh2Dabqb0xpFUsRiBunC51P1i6uahQnFQIkNbsdCdIFj1hz
X-Google-Smtp-Source: ABdhPJzZsTbs5V+jGlGVIPmp5OJTNAz4szJdfUPGD5BTq859VgJKGagheZr0km8YyX41O8llp18wpjR3unLlE2QdRCrpcxbY+eVR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2101:b0:319:d53e:5663 with SMTP id
 n1-20020a056638210100b00319d53e5663mr18244887jaj.115.1648605498964; Tue, 29
 Mar 2022 18:58:18 -0700 (PDT)
Date:   Tue, 29 Mar 2022 18:58:18 -0700
In-Reply-To: <PH0PR11MB5880D90EDFAA0A190D927914DA1F9@PH0PR11MB5880.namprd11.prod.outlook.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000024006a05db65e1e4@google.com>
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
patch:          https://syzkaller.appspot.com/x/patch.diff?x=163e219b700000

