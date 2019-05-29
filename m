Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628D62E7D0
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfE2WJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:09:59 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42507 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfE2WJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:09:59 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so4562624qtk.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 15:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aioS1jf6nbMYZpP/4x7/ERiB+ru+lseVKny3eYsdE40=;
        b=n2ZDiv5AC/qNY6Rj3sw0vh+qfSrom9p5TkOvwGBPMqWpztwBm/Q8wn/+ro2kL19V4y
         TSjeIRdYvMhHQDe/T1MjX+Rr1U8kSwM7d2v6EYZxwlotVz4nCfgEp+I6LHnag+QCWBPt
         Y+HPq5FYQJBdx221layZYH/lUiSMHoEC1Sq9BCa9OauQMH29NDbvaFiqMXDFK9uTNZ+k
         AofUrHA7pdoPUvN3rJkSdMJly6d95gRdfsOlH6lPQ9XXC5jBXqPyqlZv+uWjC4HMGNe1
         R3CWuL873xpjs1VfPxE2lH8Ve9g/DlW+tZCiUWwyY9zE71HvPbbPo+VHXPw+03uhA2yp
         KvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aioS1jf6nbMYZpP/4x7/ERiB+ru+lseVKny3eYsdE40=;
        b=oK2dpJwjXUxqVYHv/+Zm+s2JNTMoit8BDPvTQboG3Z6FI19Yd7NBe184HXUV/7JEZH
         1HX2qwCR872N4HZuBTiPQiXKaGIvDqcLUmPBccGb3sGT4ngeeSADrOjzfli5a4YLqxeu
         gT07Jo00szm+dg/wTCGfm5UPITSCcUnJkBoxWLVTg0HIBhFXfXawUMR3Z7UOswKTVcG5
         ECw27IGkGAWQwrK/IT0sz8uWJEWHvkpYkvHPJzB76xCUpF6Zxj2hbcodUnE2H6qtnhQK
         DwieK567wTEFkt75RTRA+vhvbi2l4nWwzBVd0l3UU6ZANC80s9VJ6PzJVnjAJWqB52dQ
         0i+g==
X-Gm-Message-State: APjAAAX5OV40Ukc3IusyJHGQ3ykuev6J2qaXPOlHkBwtV9v33Y/IAszN
        qAoFudLnaJVaS6Q8/4t4nvKEzw==
X-Google-Smtp-Source: APXvYqyaqxJxm0w8X4hrsAzqiVebDVw+zUwPDbrArR6LBFxdPqlfoQcK5txOS84VdSjt+YU9hzgAjw==
X-Received: by 2002:ac8:1498:: with SMTP id l24mr313356qtj.47.1559167798586;
        Wed, 29 May 2019 15:09:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p64sm478894qkf.60.2019.05.29.15.09.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 15:09:58 -0700 (PDT)
Date:   Wed, 29 May 2019 15:09:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>
Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Message-ID: <20190529150953.3cf14bca@cakuba.netronome.com>
In-Reply-To: <20190529095004.13341-3-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
        <20190529095004.13341-3-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 12:49:55 +0300, sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> This commit adds a mechanism for exposing different driver
> properties via ethtool's priv_flags.
> 
> In this commit we:
> 
> Add commands, structs and defines necessary for handling
> extra properties
> 
> Add functions for:
> Allocation/destruction of a buffer for extra properties strings.
> Retreival of extra properties strings and flags from the network device.
> 
> Handle the allocation of a buffer for extra properties strings.
> 
> * Initialize buffer with extra properties strings from the
>   network device at driver startup.
> 
> Use ethtool's get_priv_flags to expose extra properties of
> the ENA device
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>

This commit DMAs in the string set blindly from the FW and exposes it
to user space, without any interpretation by the driver, correct?
Making the driver a mere proxy for the FW.  I think it should be clearly
mentioned in the commit message, to make sure we know what what we are
accepting here.  I'm always a little uncomfortable with such changes :)
(I'm not actually sure there is a precedent for this).
