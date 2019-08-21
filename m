Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B059706B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 05:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfHUDgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 23:36:43 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33241 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfHUDgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 23:36:43 -0400
Received: by mail-pl1-f174.google.com with SMTP id go14so553557plb.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Vf1+7k1QhMXzOdyqqWc6nTCHLy9gvfuD8QGZJEzbrlM=;
        b=AcZXO0FUY9Uzev51dTDgILktD9ou0Wmv1QpDTmM/n+QKBfZLaCFrup/dw4VEOqnE3G
         7jApYdFev//DC4lmyF484tDoAKsjBQgrGftWbk9K34YnJkbh3SYLpS2DtCUw4x3Ytl2u
         AXFu1Fs1LXvxCXv4c+nQyDT9GVkG9MeJkJALfkn34WxJCxEfYDwILgPOzv+76J/DD332
         BkunateYR7FzWIIlco5fkc04rFJVywtapT3o+Kr4cz1/SVK9b1NbUBJ0kRfPxHB+v5cl
         fXOM2fQRs6YE6djlSEgwrE1RXcIFJsgCu+Wk1PHGPt68Wdrr4ifsJUU3Ei+hW4ydov++
         sgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Vf1+7k1QhMXzOdyqqWc6nTCHLy9gvfuD8QGZJEzbrlM=;
        b=smiY3Lk53rnwMa/Ha3Pcpk4KLK4zh452dfKfRBOmOMwH5LaY2otYlyF6hEoO7DRmos
         0fJI1PUPF1mJVhlBAqg7YDb6+LOwVWrGR1Y5J6buXRX4htTXNic7gXveHjFj9wMGRwNL
         45hJpqKo5fVPwaOO2eToUedlozSB/zs0RuwYGGOsbjpSg+3pNuz/GELiuxqxJkeEhPi9
         E+Nt6qwqAKX1TJr8cUkC4EAp9brPwCMHKpoHOmTVZpwuO5upqh8TP5tqMGdXK8o0xYKA
         Y2+wKhoGCPIrI9csECxTJLu+UhJo/d6nXwGC+XbKfYzLfED/HTfIMCUh38/r+iS9p7bd
         FMPQ==
X-Gm-Message-State: APjAAAUHMc36AeW5pjA5EkmsHYFan+Bx1Fx5w8ulbJ1jtoY0Fu+Y0zce
        LdHCrQBgMTeXGaijiAMKC7jETRJ8+5E=
X-Google-Smtp-Source: APXvYqx9iKb4w3eC/IRsLhlu3ygqaE+8YePy0GktQ7PRxKwTJcGE4WsbZdC30w4z6snEjCMdr/ssvg==
X-Received: by 2002:a17:902:8484:: with SMTP id c4mr30796854plo.223.1566358602862;
        Tue, 20 Aug 2019 20:36:42 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::2])
        by smtp.gmail.com with ESMTPSA id v8sm20645432pgs.82.2019.08.20.20.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 20:36:42 -0700 (PDT)
Date:   Tue, 20 Aug 2019 20:36:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next v2 00/16] Mellanox, mlx5 devlink RX
 health reporters
Message-ID: <20190820203638.71d96cb7@cakuba.netronome.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 20:24:10 +0000, Saeed Mahameed wrote:
> This patchset introduces changes in mlx5 devlink health reporters.
> The highlight of these changes is adding a new reporter: RX reporter
> 
> mlx5 RX reporter: reports and recovers from timeouts and RX completion
> error.
> 
> 1) Perform TX reporter cleanup. In order to maintain the
> code flow as similar as possible between RX and TX reporters, start the
> set with cleanup.
> 
> 2) Prepare for code sharing, generalize and move shared
> functionality.
> 
> 3) Refactor and extend TX reporter diagnostics information
> to align the TX reporter diagnostics output with the RX reporter's
> diagnostics output.
> 
> 4) Add helper functions Patch 11: Add RX reporter, initially
> supports only the diagnostics call back.
> 
> 5) Change ICOSQ (Internal Operations Send Queue) open/close flow to
> avoid race between interface down and completion error recovery.
> 
> 6) Introduce recovery flows for RX ring population timeout on ICOSQ,
> and for completion errors on ICOSQ and on RQ (Regular receive queues).
> 
> 7) Include RX reporters in mlx5 documentation.
> 
> 8) Last two patches of this series, are trivial fixes for previously
> submitted patches on this release cycle.

Not really something I can competently ack, but FWIW doesn't raise any
red flags for me.
