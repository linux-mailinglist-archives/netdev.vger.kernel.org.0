Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1AF4D6906
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 20:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351023AbiCKTTU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Mar 2022 14:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiCKTTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 14:19:18 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD265830
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:18:14 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id 5-20020a056e0211a500b002c6552a9c5fso6140571ilj.22
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=ktlhoKQNOeCfGuoq/mmQyF/fpxEUX0V4SS21GywFzAU=;
        b=vaFUfnkDC7ROtKqpgTrXbxMdeMi8lE3T6h6ojq0QWe2lCIj55q49fKPfz3J9apnzsC
         sM/XT6c/eNbJ9MZ7O6yKNrAUqs4ml0tDH0bhgl+d4kYRzREkeZhDZ44jGSPw7+OII9lo
         d3z3wX8XQgwzV/8JH+Ai4FObOH+tL3aobINIl62YCbzPVb/dVA7XGK0U08BsgmH2FAHH
         SDkF5bwV60XktkbUZAI/ds0J8QxDMOhPNiGvGXRIPAzFZQqszinpfCxbU1MsflrrcQA6
         mDJTau8EqqptTXRwNfYzOD7zLQ5hJiGS2jVfdqNW+4DxH3KZ6iuLAweuRJuxtBwsWs9a
         breg==
X-Gm-Message-State: AOAM532E86qSL2ShnB4I28v3els1TWUG5LnI/bTvWK+c6WRO7nETNOlH
        BKT3q0oJPie8KT2KN5PXemLbNdJteHdYWDyhiSsk9HtC0fJU
X-Google-Smtp-Source: ABdhPJwUhK0tMv4kFavCdi+WEOup84KAcrMGri/DGmdSZAic5cLb+iJBCtpUAz3nSKCNa0xjrHhvMxgCAm4yZ03JQUKSbHGAZ2Ds
MIME-Version: 1.0
X-Received: by 2002:a92:d09:0:b0:2c3:f141:848b with SMTP id
 9-20020a920d09000000b002c3f141848bmr9105464iln.230.1647026293870; Fri, 11 Mar
 2022 11:18:13 -0800 (PST)
Date:   Fri, 11 Mar 2022 11:18:13 -0800
In-Reply-To: <9df69909-9859-f76c-e31a-75df47738710@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002e958005d9f6319d@google.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
To:     hdanton@sina.com, krzysztof.kozlowski@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b: failed to run ["git" "fetch" "--force" "f569e972c8e9057ee9c286220c83a480ebf30cc5" "3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b"]: exit status 128
fatal: couldn't find remote ref 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b



Tested on:

commit:         [unknown 
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
compiler:       

Note: no patches were applied.
