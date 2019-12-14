Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379BB11F51C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 00:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLNXs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 18:48:26 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35562 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfLNXs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 18:48:26 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so1480454pgk.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 15:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hbu8c3BS7REuBfMXNZZ8oeORXt2ILe79YUYnVnbGTVA=;
        b=EaIC89UCB+IgvuLvUDBdQmtgLlMPDjPYIyZ4EREwTUDPT5LOetOiVM9s67JzYwPKRL
         DJgpWLlb/CE5THjXOt9Kaf2I4JRJo59Ldiw1cMNlMN75OKuK2FYjAW+Rh1KRVOHJdy5i
         c62/MtUOfUzvWa/cwbHPtkZf1w5p7g/gYZs3co2IiXmzAWSA7caM3jY65IHBUSXaDRFQ
         qPSBRJKnDuQRRjDgp20iTApNyye/lMjZ+iWOijOL2pc853rYlwUhp4qpxo1wLGZGekL/
         0z/0Cff2soXHaYDdMXfdBUsfPflbsVlIbhIe3khff+Qj4TBJPBCKdF2TXvXBGsE86HBD
         Fk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hbu8c3BS7REuBfMXNZZ8oeORXt2ILe79YUYnVnbGTVA=;
        b=MG0juh4bQysT3AskzrCCfBJAz7se5t7oaQUqTkFMNbpqsElCEdmSDWTFPYS5UjlUVu
         RA72iSq9CJeqGZGWo5/b38IkNwbD8kgaJmV/7gTu8mxVguhjbdjhKktFlSxHfn5Fotk/
         T1BZWyOlmO1ShEsVlHnbZfz9ku4HvFpOZWznL/Y1fHZ5A6dgB1KxYMVqn1MT2Wf1iKVC
         d/r3DqN6mUyyW33TC2ETy5tm5aC6atTVaW3rsb0LTgmr17NDlfWmYJichUd8bYQ4ef0H
         j12rUvYF12xp//0zVIxdXwIOH6TY+Y8Undr80G1DcmzxsP+cEgj3FRhrHroDncUCEJzU
         RYZw==
X-Gm-Message-State: APjAAAXHbG/LY0TBRZF7IMNgDY3AbL3PpbQbxWvrALMfxsc22RJlhLie
        qh4dFaBEiEOq3fHNq2wkBClUBH+jD++y4Q==
X-Google-Smtp-Source: APXvYqysJhiQMJFDVg9/hSuNSCBfM/lORUWURvf16PTbRF+UhsPSH64RnK+SgOhBle/DZ7gPPE8ZMA==
X-Received: by 2002:a63:1807:: with SMTP id y7mr8225737pgl.94.1576367305721;
        Sat, 14 Dec 2019 15:48:25 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q8sm15996089pgg.92.2019.12.14.15.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 15:48:25 -0800 (PST)
Date:   Sat, 14 Dec 2019 15:48:15 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Wilk <jwilk@jwilk.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip: fix spelling of "Ki" IEC prefix
Message-ID: <20191214154815.3143023b@hermes.lan>
In-Reply-To: <20191212215414.3655-1-jwilk@jwilk.net>
References: <20191212215414.3655-1-jwilk@jwilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 22:54:14 +0100
Jakub Wilk <jwilk@jwilk.net> wrote:

> The symbol for binary prefix kibi is "Ki", with uppercase K.
> In contrast, the symbol for decimal kilo is lowercase "k".
> 
> Signed-off-by: Jakub Wilk <jwilk@jwilk.net>

Why not just change prefix to always start with capital K.
Looks like that was should have been done in the first place.
This was introduced 3.17 by Christian Hesse <mail@eworm.de>  
