Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E1DA42CB
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 08:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHaG3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 02:29:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41498 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfHaG3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 02:29:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id 196so5947237pfz.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 23:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/BHNsyC0Bo9k+dGdG4N5L3/SfXNhKCHX/7d8QlNHx+s=;
        b=b5fsgpaupYb8+53837HXv4PWxkY6WqBCeozf7glEkttMq/9bNZXLxCo4ke0XwE+8a7
         HODMITTxIh/+noUffFUyFj/6KCsyJhRyRRhWQScLBw3RgmezXBzhr4J6sjuHwc3j6spe
         QWEuZU/07YQsRQyiJBNOWxCJZ+EXidranTjoHhuL2/ZPd8rV08fUduLp2eGegG09fpaY
         GA8MpPgCrocXgLgEoBtXH7CfEsI4a/YTn3u3pZpjnSAZV+EgJSuNcr4AATlH40qswNnR
         CshGaAoSXh3+kZviw9cbsUiPD5TBHEeIUB2yLuit7nn0eFFklRWBXbnthkqbu8NIlbMv
         ScbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/BHNsyC0Bo9k+dGdG4N5L3/SfXNhKCHX/7d8QlNHx+s=;
        b=VQJnYBa+KYCf54QSAemWpfY4b6gTDtI5yGLaVEvlSe6N6aBYVH9fvnz5Lq/cZ75oKN
         YIIg1kqaXhohLzUdnNkcdQhBzoRzstbabeukEL+iRNGjYAzp9PP92v4Ny/cLzzf5z2/d
         vl2+Jczrdrrkt5ZAca0Rm6rPH9CR/sYLW9FnliyRI3p5fax7ejUgmLN86gJXl052J45c
         zHPWgfX931EoproJsR+XmTsTZ4unp/B4EInH5AIIkBZJ2W0une8X+2R6aMHQPx+QE/3k
         GXtUF7EwwFs/MLeHyJVvTB/byCSOKwo70fSRpwQ5zYCqeeO3oA4cKL5IeEc2s0rXCC8m
         OAYg==
X-Gm-Message-State: APjAAAV1/1aHE6PtlM/JlYrcnc70h6hJqSUu1CjhLYt+tSocF4tvCkKi
        srInTE08bcmjavf18tR48CVzmxpysfs=
X-Google-Smtp-Source: APXvYqw05VNWjqnKDOhWqC92KFTTtPSXXj5zHel4bTtmOEJMat5SUsOlMkIxWbdqjn1OgJIBntvmHQ==
X-Received: by 2002:a62:aa13:: with SMTP id e19mr21630370pff.37.1567232959612;
        Fri, 30 Aug 2019 23:29:19 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id n9sm6860439pjq.30.2019.08.30.23.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 23:29:19 -0700 (PDT)
Date:   Fri, 30 Aug 2019 23:28:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 0/5] net: aquantia: fixes on vlan filters and other
 conditions
Message-ID: <20190830232856.6200abd2@cakuba.netronome.com>
In-Reply-To: <cover.1567163402.git.igor.russkikh@aquantia.com>
References: <cover.1567163402.git.igor.russkikh@aquantia.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 12:08:28 +0000, Igor Russkikh wrote:
> Here is a set of various bug fixes related to vlan filter offload and
> two other rare cases.

LGTM, Fixes tag should had been first there on patch 4.

You should also perhaps check the return value from
napi_complete_done() as an optimization for net-next?
