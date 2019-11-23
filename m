Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F70610801A
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKWTOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:14:17 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35477 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWTOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:14:17 -0500
Received: by mail-pg1-f194.google.com with SMTP id k32so5083465pgl.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=22ivoNBeHyPogdV069x9kCkXPo2r8doBNzJKz/A85OQ=;
        b=wWOb0A/gqLogGWKHrF7bTczcXfwYiB1JyTqTb34pz+xRYRhS5izMWqk16HsDCjNHfY
         L41lcXQbOHImsb9Y/f5H25QmF3gCgukexd7MiG1B2W19imkabzqgv7CuS5Q/BnjDbRJH
         nsMWu7l1w4jiKVenswny4N8fvpUDvV67/vkx4wEfBQr+oA6NlRWCZ8uuZDw4DdaARNuE
         O9Ko92QFOxWntdBaT1TG3H2/rEqbxyl1vpJ0nkZk15w3RtQeeQalrorkxVRsKDB+770M
         aPPBAJTU7XNda5/G3kz0qOd86u1Vj8yrKVNSH1pc7FHWvQa/v/3yuQUvGuFRXsrbv10i
         5JRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=22ivoNBeHyPogdV069x9kCkXPo2r8doBNzJKz/A85OQ=;
        b=JOi7RhHuDG9jGrOLBrN9tC17Y7Siop4YcwK+W5zuELjHlMp1636fX6E32FKC6yPvhK
         OrntmU1fuMWvMQSxhGCmklxKYzLGBkLfMGA3xJLhlSaZ8HapdNBCW7GwKSCuZGiaHLm8
         TREzkeF7sVDJqJqhvXj/fufcrFmqm9OBEKBZvcAEFcZNrOnanRlCtwwHg4HVPI/DoYXK
         ZYWsaO6lzEy5hlq/UdT6yokhlGeY3Zw4Ry1jZ0UW0LnMOwg5c190L/9UHuqM8pmdYEC8
         pX99fEIqoPu3RNMlG2DkIitXELloEkPuHdwgyMNG7J11J6hiHGzc/LRce3Sm8teIMQwd
         1ang==
X-Gm-Message-State: APjAAAXqxuhOMBkDrtQqqMV+LVAk2x30TO0EbOGJawG+ZuwIb3St6l1P
        bWH6xlh6UfR1juueYRmp7OMNvJ7Zv4M=
X-Google-Smtp-Source: APXvYqxskLAiUluoLnaXCAGfk1CLUpX9f4H3yUCPS/07vbwUiY36bRuXHz+2mGcm3TAY/LpeIA44ug==
X-Received: by 2002:a65:4cc9:: with SMTP id n9mr23978036pgt.426.1574536454576;
        Sat, 23 Nov 2019 11:14:14 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x2sm2581014pge.76.2019.11.23.11.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:14:14 -0800 (PST)
Date:   Sat, 23 Nov 2019 11:14:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Robert Schwebel <r.schwebel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] docs: networking: nfc: convert from txt to rst
Message-ID: <20191123111409.75d7b2e4@cakuba.netronome.com>
In-Reply-To: <20191122074306.78179-1-r.schwebel@pengutronix.de>
References: <20191122074306.78179-1-r.schwebel@pengutronix.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 08:43:01 +0100, Robert Schwebel wrote:
> Hi,
> 
> here is v2 of the series converting the NFC documentation from txt to
> rst. Thanks to Jonathan and Dave for the input.
> 
> Changes since (implicit) v1:
> 
> * replace code-block by more compact :: syntax
> 
> * really add the rst file to the index

Applied, thanks.

I have a question and potential follow up to ask for, though.

When the NFC doc gets rendered to HTML now, the "The NFC subsystem is
responsible for:" line is highlighted. I believe this always happens
when a list immediately follows an unindented line, in this case:

The NFC subsystem is responsible for:
	- NFC adapters management;
	- Polling for targets;
	- Low-level data exchange;

I've run into this writing my own docs recently, and I wonder what does
the highlight signify? My understanding is that the highlighting is
done because sphinx assumes the line proceeding the list is its
title/heading.

In most cases (like above) it's not really a heading so there should be
an empty line before the list.

Is this correct Jon?
