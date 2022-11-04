Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D561A0EC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKDTYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiKDTYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:24:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCAAF78
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:24:19 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so5347840pjd.4
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 12:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=magic-biz-com.20210112.gappssmtp.com; s=20210112;
        h=importance:content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a01HKBq+YM6w+MVN5U0M0jx5bnfgZpao5x+lzAfOY/0=;
        b=4lb83jesme7vPCPaFDoCw/8KqYTelwVudTiXnU9KWxQO5YKvSk7f/Zx1LREyNSjZT4
         jIqQDtBX8HnDJgztc2uiDzXGDbXTkHGpjPhAGLct8t4l/45+2cQbSZ5ukXh0aJAFJ35k
         gzjDNa9bvDQ+nhAIZj3Cqxw1TlNaJoqaq6kmAsoCkDJWsbN3w/7MXmJZHGN5rcA/jSEU
         E0qYR4CfrTaMXLKppHp81DQGxQbUQE1YorGhW+HS3tSdRDmxh7FqeDKCmj6ZiTQiSwZp
         ymYPt26eWEbVcLx2BWsqCe/Szttw1qC8b/xBBtNp8UeIh20YjLUyDToh1eEP5b3VFgDG
         Xn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=importance:content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a01HKBq+YM6w+MVN5U0M0jx5bnfgZpao5x+lzAfOY/0=;
        b=h+6wQWnvYhgb1BPao305qd718r4zoywFYV+1nadH5gcWGjk8ky36V8rH1hvRBTs4N2
         VLcStWeVD4CkLp5Xuv8ixRonZ2A4n2qwceocyHpBDe0bFOQqU4mIeynMU5kz7B9oUmWp
         LLGG+58TqeuhAsCUHYvpz4ystgSJaaqr9ZWU1Q8gYNYj7cyvZ3o9Ccs49pKaYej9P3jx
         0eyO7M+lu6q834IY9h+GvO5GRRqAp3DYlJMlf/3239MX0q+PJCjcpR1NhAOzap767svz
         vEYPZ08xgBG6i6B07J1HyWWGGEhFLRE/QjcuOSzv7bS7KFMf/wTqtHOyv6lcQLwNRpW/
         0bmQ==
X-Gm-Message-State: ACrzQf1tCZ2Q1Gkb3J8YOgpmLWeTPP48AwlkOUDI6qtHdQyIaj6lGb5l
        CLeNu/rol0+G/uDb+9o/HWbBCQ==
X-Google-Smtp-Source: AMsMyM62BqK0g383HETKHzTleywNocFT/ftVeBWrbF3ceSs5OPfYDVT5hkyH6pvqz7aeo/M74YHNbA==
X-Received: by 2002:a17:902:8693:b0:17a:f71:98fd with SMTP id g19-20020a170902869300b0017a0f7198fdmr37081124plo.25.1667589858670;
        Fri, 04 Nov 2022 12:24:18 -0700 (PDT)
Received: from DESKTOP6C94MB6 ([2406:7400:63:f7e5:255b:7208:7bcc:6c8f])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902e15400b00182d25a1e4bsm98103pla.259.2022.11.04.12.24.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Nov 2022 12:24:18 -0700 (PDT)
From:   "Veronica Paige" <veronica@magic-biz.com>
To:     <veronica@magic-biz.com>
References: 
In-Reply-To: 
Subject: RE: RSNA Annual Meeting Attendees Email List-2022
Date:   Fri, 4 Nov 2022 14:26:21 -0500
Message-ID: <362b01d8f083$b1707970$14516c50$@magic-biz.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Adjwgpts0Q3fv7t+R3uFYLuSDPKSSAAAGLrgAAAA0BAAAAAqMAAAACXAAAAAI1AAAAAugAAAADBwAAAALdAAAAAsgAAAACbgAAAAJkAAAAAnYAAAAC/AAAAAShAAAAAj0AAAACjwAAAAKbAAAAAoQAAAACrQAAAAOzAAAAArgAAAADKgAAAAKqAAAAAtwAAAADxQAAAAMUAAAAA2MAAAAEfw
Content-Language: en-us
Importance: High
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I hope you're doing great and staying healthy!

Would you be interested in acquiring Radiological Society of North America
Attendees Data List 2022?

List contains: Company Name, Contact Name, First Name, Middle Name, Last
Name, Title, Address, Street, City, Zip code, State, Country, Telephone,
Email address and more,

No of Contacts: - 40,385
Cost: $1,928

Looking forward for your response,

Kind Regards,
Veronica Paige
Marketing Coordinator







