Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96095E8FA1
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 22:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiIXU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 16:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiIXUZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 16:25:58 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25DA3AE5E
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 13:25:57 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id l7-20020a056830154700b0065563d564dfso2158874otp.0
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 13:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=m7KtlTRQ/940R7kWNpP3Vz5Bs4+fmR2cZz2mXb6ruwc=;
        b=o/j6TYB0hLCyOCwHzpUw/Hx4WFeL4LjHBvDhaTRxy9nD5L9Yj5MY6N/S5xXVTz9Ca+
         qp/aCH97Mro/J3JLa5sAUX7LR3H0y5Acotuh0v1QpM9vpyAa0/9In5kBDrokKy3xmTG8
         szZSroRthPVEHP0X9LuZ3BLZaEqhwjL3w12FmEY8xgW4OBRutjtOaifcQdn4QIykPu1l
         JNC5uDB+dPiW4X3vdK8emHl5q/HgAlWHlpfhRrtrOxrMoh+d/83RsCd79+65336W20h+
         xFDm2i6ZIFdNiREg3eBOxB62f/4TmeTQjzPllYmkg3wFDnl1iQjmjeVerlqMqhYd6Hpu
         d1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=m7KtlTRQ/940R7kWNpP3Vz5Bs4+fmR2cZz2mXb6ruwc=;
        b=T9zg0LT0wE4yEGZra5q1DYN8PqjeZ4yNcI7hkRQYOIfz9H2jthiPyeynD3a9Jg5f1/
         ClhJd/l1h6cHhfqk6vZmcBg1JPXcCoFAwRm53ve6V0CRlz6iXOebV9u9gzT9SX7ZyZ+O
         Ef73YZPj3i1Yk/qTV7U76/f+T9HKSa36J+VhcvNyJpmA7nClECvG9P+XOeFnjakOAb+K
         79O+MjDCMgcklIwf7apiq7tTfGrV6YD/kV0tKsCUoCz3rvxfZ7ufs+sqsr7tBkz69Btw
         fcQtyrwcVEMlVhF99h3YNTnRY2F41Z87ApJ6ot0uDT+6VVStXP9A+c8NVL0eNvRqMdfP
         NCHg==
X-Gm-Message-State: ACrzQf0nApBCFzuxX783MS8c6gokhylUkVjlM043bVK9PMtE7A8UJPV+
        r3TFvOtlW9ZXNK3zCgDR5MRm2B4Z2boHlEu5xKY=
X-Google-Smtp-Source: AMsMyM6z51yFXoEklRool/IqRRMiGtlU3wa3BoMhOtLoHawAZv7ySC98Y2CXOkjdMuUTD+uAtdX7/C5OuhlEU68beUc=
X-Received: by 2002:a9d:7d81:0:b0:655:d419:54f1 with SMTP id
 j1-20020a9d7d81000000b00655d41954f1mr6734330otn.177.1664051156968; Sat, 24
 Sep 2022 13:25:56 -0700 (PDT)
MIME-Version: 1.0
Sender: anitaabdallae2017@gmail.com
Received: by 2002:a05:6820:1620:0:0:0:0 with HTTP; Sat, 24 Sep 2022 13:25:56
 -0700 (PDT)
From:   Monica Karim <monicakarima38@gmail.com>
Date:   Sat, 24 Sep 2022 21:25:56 +0100
X-Google-Sender-Auth: M8R9IfuH1a2dr9wfueHCFNfAvTw
Message-ID: <CALrj+s9ER815OAHKR8TATZJFKZPk15BNbVkG40UbsBtgKK9M4Q@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How are you? I am Monica a Nurse from Netherlands .What about you?I
need to discuss very important thing with you.
