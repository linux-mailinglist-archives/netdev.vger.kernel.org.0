Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9EE3532
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502785AbfJXOMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:12:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41563 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502739AbfJXOMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:12:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id q7so15238728pfh.8
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 07:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JkABUK+bHiJs0o8jG8ts/+Gr936RUC+fIAH3anzcOfI=;
        b=cNPQrV27ZWtJtq3gHeMRuO1zXoz2wi3T6F9caZ5h+YLHP2f4zipvFsO+5vz8A+qcQo
         grUZHIT/LrjQcTkzVfphXSSSu6NcDidcwO0HT09BO0dqSDzMyi4WJ6P/Bpkn01N8iJGD
         BSnywZbRhvHx+lezdJuxRn7IoEmqpnJBMsKx9Ke/1cw83YR1xgMKDTlIVY2HxWw/dTgP
         JgX6yGbAftmhiBZEOwtdGicHYVA4qO5IShf7lJ6V+bWgJayPt8/WscXzR0QRhM2dgBAm
         DOR5+IXZoGsgX2rvWvvMluAm3ZhD7uSgsj2NPx/XREPQPidjAoaQ/qLO9wDMzAm45hMq
         Aehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JkABUK+bHiJs0o8jG8ts/+Gr936RUC+fIAH3anzcOfI=;
        b=sqVGpzQB/wr/FdSRINA2YBo5TCfgVQyM8uBx4FI7i2t06nna89c7cT7+P2NGOGfj65
         3JNA/AuiRffAXnNF/mZgEMh0LPL5TcdS5yId89C+xNb1uzfJ83Z/NsScYL1aM/WT06oF
         HaGPCvbzeuMbvry8gKB4szmL75l5sk4hArOqdhGPbLnagwMx24cslHwYCFBFUkTbZYvk
         OkEsViq9CmdztnvLKniMtsMSpGdqyAmbkIUvEd9iE+E36uptWfkYiJWeGp17b6ZEfoB5
         FkumEzaLuh4kCR0iXkUjHliRvoJmzSqDdw9190qpjoVJzQH4hG26Yki3DRX9WG28K9N6
         EiUw==
X-Gm-Message-State: APjAAAX4ZW6PgW1BvjhqfLvucWEwEuZ1NwgZI4iFrLMmamdrxzAlwZgq
        9gGVaPXORGsTCKHe+cUqD5Y=
X-Google-Smtp-Source: APXvYqztCJExRj+O6+iH1ku79737+ZY5MK6ydbrGCxBpc4Ymg2JTw7B0XwPJibE3JpInFLJxNsMr0Q==
X-Received: by 2002:a63:e156:: with SMTP id h22mr16546647pgk.266.1571926340947;
        Thu, 24 Oct 2019 07:12:20 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y80sm27964793pfc.30.2019.10.24.07.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 07:12:20 -0700 (PDT)
Date:   Thu, 24 Oct 2019 07:12:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>
Subject: Re: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC
 devices
Message-ID: <20191024141217.GC1435@localhost>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 09:53:20AM +0000, Igor Russkikh wrote:
> This patchset introduces PTP feature support in Aquantia AQC atlantic driver.
> 
> This implementation is a joined effort of aquantia developers:
> Egor is the main designer and driver/firmware architect on PTP,
> Sergey and Dmitry are included as co-developers.
> Dmitry also helped me in the overall patchset preparations.
> 
> Feature was verified on AQC hardware with testptp tool, linuxptp,
> gptp and with Motu hardware unit.
> 
> version3 updates:
> - Review comments applied: error handling, various fixes

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
