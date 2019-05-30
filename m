Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4428830312
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3T7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:59:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39784 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:59:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so2621388pgc.6
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 12:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sdQClCLwKzHdomTaYzuVvl0VyUqvASBZuWBjpxPHQH0=;
        b=yW7BsXBElOmLcQ+aHnp6hOVticgwRbUfHpR2GIkcYKX2WhOjC+KbxMSOsfOdW3L7YQ
         jNKqy0dN9mClv+/aO1RzeWRecebggxNnlMJXORIA5U1X3uVLMnuPEwUrsQirXKWo0Oi6
         r3X+9jLYr/vzq1IuQOIqYmJrvS19wUyZaynNma05D0UTqE26bbrCVNkV1ans/hPpw/NC
         zfd7aBKDvVKuvhwLb3J0mbSoAUEQp3uCU6Y0xgHNLzB3rwNEdwWlm2EWKH8dd1mETt99
         8kFKhxRjihxmkEwI0kakPk2k5yWviYZGRePr5BUPDFuIheZ75Hqxk7nvsKtQI5XwF8oh
         iusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sdQClCLwKzHdomTaYzuVvl0VyUqvASBZuWBjpxPHQH0=;
        b=EuPbybNrKiXCuy9dNsyBOfvZ2wO8mVsT3GLd57AIYNxA4pCzrxBDaMJrjae/ttU1lD
         60eHEbF94eZyp4GXIeuaEKbr93zyPwXoDa8SFx4YcGI/C0oYoVRROb68+e/sPHxAl8jJ
         CK1iNCmiaGvIutMQvTjJST6jrsdPGggPPQBUMqbp0wOsTLSFTS+COOhOeyvyuv2QgDVF
         0qL6hVD6P0d1IB/7f7DKVVQP7xdkLr01h5POagzjZQxlgBhHkf7/1nDyKKmxaqTrExPz
         LL60xDjURvz70Nn0UkkEPpg0tRU6Cj93kBHBmGhdcmgb1k9brQdnWz/dy5QEtF751LjV
         UVog==
X-Gm-Message-State: APjAAAX0tbLsxrarwZ6AeNNCEDmX7cH58vIhrISlBvyP9N5a4UNYE92b
        9/0UPbshYD7AyVCGi2aIR7u9xLJAHdc=
X-Google-Smtp-Source: APXvYqycyg+tiWyJqpphmmSGT4XCCJasto44lyKPZaJpWNOY5kNGRpX7t1N/fc7aGkmO4B4zCZoLKw==
X-Received: by 2002:a62:1b0c:: with SMTP id b12mr5319078pfb.230.1559246346843;
        Thu, 30 May 2019 12:59:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h8sm883793pgq.85.2019.05.30.12.59.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 12:59:06 -0700 (PDT)
Date:   Thu, 30 May 2019 12:59:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Message-ID: <20190530125904.713e72b1@hermes.lan>
In-Reply-To: <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
References: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
 <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 16:43:20 +0000
Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> wrote:

Please don't use HTML encoded mail. I.e not exchange.

> +
> +	if (argc) {
> +		if (matches(*argv, "dscp") == 0) {
> +			NEXT_ARG();
> +			char *slash;
> +			if ((slash = strchr(*argv, '/')))
> +				*slash = '\0';

Don't mix assignment and conditional on same line
