Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D5368B8CA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBFJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBFJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:38:47 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E97A126E6
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:38:46 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id w3so12099114qts.7
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 01:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cPlXAa184OzGg19tbUC4ZTLVQ9TVyFK8n/f53G1T0Uc=;
        b=RymZH08XUaWjEmzRl8tYbmXY3nRxehhB5/DzUlddUMd59Mn9WCvjBZAIWebzi+1aRd
         9P8FHjDf1Y4Ssn1v6Cd5xoWlLsJx/kURQ/TWbbGWIlpB+PLyfDeGlzvDIxBgRNFWAQne
         7CPOX+N+0/Ngw1nCnGyhdXuhyfgSd9ZO+BemI4Vu4sxdUrnx9uZpmAkey7U0XhnKUjeL
         E/avMgkuDtExgs9jzYXsMZ2tx/fh9QgCix0GSEi5+ziPcgZ+CEFcIbbeuVhemXiTk+a3
         ywcMg/vA+hbiwfiEK1r6sqcczDcMTRwBHK4FFVXgkUYKov19X2PVnbk4OGz+SRSBtSym
         3a3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPlXAa184OzGg19tbUC4ZTLVQ9TVyFK8n/f53G1T0Uc=;
        b=V2tx0ZAlNN/c1/qMViBdL0e4pxcvJrBFj6BatsXC5p5o1sYpcyV/jndZSIwJGMg4da
         x6BD3gT9ORI1NZPbRyk9LMbV/2Zpy4ndlXbe2TtquVViM/ql/ok/sygM8ryUb9TsQDQu
         ElzaaNCimIstnmjtJ6bVABtlTN+EgGU8pGAfG/LGKrJRft/s0una1bORmi6V/giLlL8M
         asEVvckha75RZ5C7+zRXJacvWufdRwsRZTLy7LadCgOqC4C5dkbruPcWAfrFAiV9KR4f
         Djd79s0AYIACRbWQVNgOUykn9Od+YI7Q8inV1jLxwkRkxl93fnJA5bcfzaryRC5ImNr+
         qzYw==
X-Gm-Message-State: AO0yUKV2b5nK6jA5z5mr7Z5/dkG8zUzaN5AaZl1Ar9XQ8CDDz55Ve8I3
        o4j8TGFkm91pW36j/gvF8D/hWBJCpx46lYZkv7c=
X-Google-Smtp-Source: AK7set+XncbtEFDT1z5CvhgrnFYsh0zpxVFl4W5601rfuw/7u02Se1bn4d/ucXd88dfm45OWXAm+UPgBf5MdvCISPv8=
X-Received: by 2002:a05:622a:1041:b0:3b6:8959:d97c with SMTP id
 f1-20020a05622a104100b003b68959d97cmr1796440qte.374.1675676325391; Mon, 06
 Feb 2023 01:38:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac8:7113:0:b0:3b9:b5ea:5a90 with HTTP; Mon, 6 Feb 2023
 01:38:44 -0800 (PST)
Reply-To: loralanthony830@gmail.com
From:   Lora Anthony <mkuseli011@gmail.com>
Date:   Sun, 5 Feb 2023 21:38:44 -1200
Message-ID: <CAOy7HNk5HeHyUFEg84MZPjXOEF2tJdA6muPZDqEMhjW=0vOktw@mail.gmail.com>
Subject: Get back to me urgently
To:     koffiapo0011 <koffiapo0011@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

307 Birch street
Skellytown,TX 79080
Phone:+1(219)237 4122
Date:6/2/2023

Dear Ms,
My names are Lora Anthony from Texas United States of America. I am.
the lawyer representing Mr. Oleg Deripaska(metals mogul) from Russia.
Based on his directives i am contacting you for the repatriation of
investment fund (USM6 Million) which was stuck by western sanction in.
a Togolese bank

However, he needs your assistance in the repatriation of this fund to
your country to enable him to continue his investments aspirations.
hence the money cannot be allowed to find its way to Russian economy.
because of the severe economic sanctions placed by the western
governments.

Note,30% of this fund goes to you if this offer is acceptable to you.
contact me on the below details for more directives.

yours
Lora
Phone: +1(219)237 4122
Email:loralanthony830@gmail.com
