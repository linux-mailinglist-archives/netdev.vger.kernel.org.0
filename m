Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381926549D2
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLWAqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLWAqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:46:18 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0AA1DDDB
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:46:16 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id 1so5096623lfz.4
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=HmKdiMEz7QbRAjTlDVKIEk1cNWEGTZfJVRhfYXeEWBBrXuddJzYNjJz2mYRh0RVnu3
         FQ3t37YSF4FWSXWesozXmawLLj2pw862saTV9RPMO0CIwDuPZOt0+5ogwDzCdGEyX12N
         7TTpQPxFmKVkRMQvjR8fhBlyDPLJ7LFUmht4I2I/oemKyiu4vSUsPXlrpwsWedCVgWiC
         U0QFVJDnpODexWn0hGr/Dd7bKAIzzBlu4Pp6EHo9Yf9UHtjfTrjy8di6FkF3V72LBsWL
         A3c5eEmMxZt7NbKEO/sUsbW/vKbarw9oivtbD5KDozxYNXscxFmmgWH+uTl0Sj3o0D2G
         rwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7XukgsAlfYiKI+yuvdwyFpb/FGCy9p+ybfvm0wRi4Y=;
        b=SeSHCT6DQ7Dwpp3cvbvBQg4ja2UjMcWs9KVndq0UD+fw4zrMH3JbyRodcCmAr/FIzN
         1RMyfTdQI1/1mTa94IrUevu75lcj+bQd8IJiQAhLBU74250fccyFPNKQIVTF/1t3zcE8
         9VJEfd2mBS7+SCp7qVbLyAq6VfFRPPTE/3CzkJeyApF2V0/TO5FzlIGQ/TmMZSThotDe
         8sSr5GvZ/XLrGIERaa3FCYx3fRZMFZy7ek+qM7yB6o2xD9i06y+L3gAzkRqeZly60EgP
         Oi5CHO0lE+ukO44/ey3uHGKUn4zKKg/OFs5rJb16MAnBCrlUtMtyLo0l7pHNQceVTeED
         uyNg==
X-Gm-Message-State: AFqh2kriLesL5LW78LZnWxMXDLLJo4WYAsYmVqjlOPnw56SKUyqdCCLv
        JgyZ19z67zgBhJj7TsajPiAO2zMpT6StF4+W0WQ=
X-Google-Smtp-Source: AMrXdXuyCsFMwnNHuEHDqftI7F/o5GT8BRCF4cCYD3bRD+/y7J0ommXe3el1IZYpouPLBxATPXfjSvViPp1xogWqoKM=
X-Received: by 2002:a05:6512:2507:b0:4a2:2c23:a6d4 with SMTP id
 be7-20020a056512250700b004a22c23a6d4mr335148lfb.257.1671756374869; Thu, 22
 Dec 2022 16:46:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab2:5996:0:b0:17c:7e9d:5fb3 with HTTP; Thu, 22 Dec 2022
 16:46:14 -0800 (PST)
Reply-To: ab8111977@gmail.com
From:   MS NADAGE LASSOU <nggdgd715@gmail.com>
Date:   Fri, 23 Dec 2022 01:46:14 +0100
Message-ID: <CAMcnMex7NJbQx1xikAU-nJeyZe1srzYQztMnV8hUNXwh+LfUgw@mail.gmail.com>
Subject: REPLY FOR DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:141 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4981]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [nggdgd715[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ab8111977[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [nggdgd715[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have important business discussIon with you
for our benefit.
Thanks for your time and =C2=A0Attention.
Regards.
Ms Nadage Lassou
