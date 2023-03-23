Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2757C6C5D4C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCWDgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCWDgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:36:37 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FF2E0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:36:36 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id q2so6170385qki.3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679542595;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=Ji8daujdQCj89y1DK4vws//qnfm1CkH1tOXQ4Kv9ez++f5vtznd8QvkjgyHkc4oZOW
         42KVNYZg+7wgUrVLzM9ypIEXL49JJfZt7Af6Ae/zdR28TpBV6A37fjeUko40fqjeK7+3
         ZhzfoSPauWiGnsDlRJEeWSDeih2hHaQJ7yiG6OYrwf86xTCW+/Gi3UGXTb5JzGPzwtww
         o49yWLEcUbVD7Onkt13GrhVrg1rjwvZdeUbGQpADl0CYiYrapzHkTNA7Og6DKZTTmFoA
         FbYNXaHn4JLSPdDhn3vrhZf8plPTfXWvXyqFSI76V4gIuk/E7EE7xykVy20QYHH0swhJ
         MC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679542595;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=KPQSr4Rzeu9R2Jfc2xO6SM0a0LyEwSzJEvM/6ni366SuoOqYaR7ngWnSQmB+msEwim
         qETPxmH1FH1FFH3TZoWl2R5dLa+753HQA7TLouKLPvbAcd0vFrP9lbrcqVMnFtkeUonb
         1nNeflGua2lGc/nDjzYcLoRLjeC85iXDwTfmhKiWl0xt4mrmmCijyWkOiS19UwMxR222
         RarF0HK53i10dPOzcz9TiP/SV4qPuXnDnXrzZfoL21n5uNBINDIFr1oFYMpEhCHwV2AP
         IlMNPRnpfJdxzMaEeFeeTFgWj9ghxQUzpPhngr5wdsqUWQxGPjANlb5OPaOEcZmW37Rn
         0RFQ==
X-Gm-Message-State: AO0yUKWz0ZP+NSxVDG/a1e/4xE4iBFJJQ9Ge2u8wXyHY5UzJ60FyZkga
        jVK+jxtxYgPl2Xv8rEDrkA2jmDctalNM2ZubnOQ=
X-Google-Smtp-Source: AK7set+9x8oU7Shtq6+toYbK5Cmv4qPKfGV9fSPZHCTAk+v1GdlwGQeiukVqakObOtEmG2ksMtd0ocwAyGzTfL0XkPA=
X-Received: by 2002:a37:ac1a:0:b0:745:6afc:9bb2 with SMTP id
 e26-20020a37ac1a000000b007456afc9bb2mr1047835qkm.14.1679542595623; Wed, 22
 Mar 2023 20:36:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: hannywilliams05@gmail.com
Sender: agentcontact0@gmail.com
Received: by 2002:ac8:5f51:0:b0:3e3:894e:f0c0 with HTTP; Wed, 22 Mar 2023
 20:36:35 -0700 (PDT)
From:   MRS HANNY WILLIAMS <hannyw787@gmail.com>
Date:   Wed, 22 Mar 2023 20:36:35 -0700
X-Google-Sender-Auth: rhod2gaOAcsB2bdvyiCOxqc71oU
Message-ID: <CAAVe4bJOoaROxZgNi9BkTJ2JESyAx2+MSDhG6LfN-GFFwR6B=Q@mail.gmail.com>
Subject: I Am Mrs Hanny Williams, I Write For A Charity Project Cooperation
 For Your Kind Consideration Contact Me For More Details
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,EMPTY_MESSAGE,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:734 listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [agentcontact0[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hannyw787[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [hannywilliams05[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.3 EMPTY_MESSAGE Message appears to have no textual parts
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


