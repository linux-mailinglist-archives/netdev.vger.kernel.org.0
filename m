Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA72D3685
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfJKAs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:48:57 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42976 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfJKAs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:48:57 -0400
Received: by mail-qk1-f194.google.com with SMTP id f16so7368872qkl.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QU4wqiF8JyGpQM5MISLkrt1uWMuNVRRyuUjZmBQ6ej8=;
        b=a2HrG71ePNNWoHJSw+SvYuVP4ZxWJ9fpQ/PWLjjFbbobTU81mQPXkouf5Kv5PnFvoE
         XVRbO2TUAnUhXGGi4aaUmFu38ZSgBGb9EnLIpp2tfaqufd22zXQykJpNShMnvxzwK8qJ
         i6gKV8B1a7wbjUUMdInwGR58oDZG731zm0BMdFq9yclFP68ED+FJOkLZCyZTAm/ud7g6
         8AMh9XD4cTbEXJccGmaeRcflgfC0TS2QDxkVGQmQx2l6JR5JsjbzgWSl1oeQuzzima/N
         RtM9aAo/HWx78cb7p8U+RjXEQFK0XxWcEWRY7LVw02g9RlR50lOSQk7nLaxeqO9AxDGH
         CwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QU4wqiF8JyGpQM5MISLkrt1uWMuNVRRyuUjZmBQ6ej8=;
        b=m+o5N/GDyK5BYEPreUpFjbihyrIr9ZzhEx9pH/IdPKzBONztsKiYIXzTYfSPcCOpd3
         XsQRDluAnWUKOKpPm6gXJc/vWJQgNNMOIO4dp/VENuyuv+bCGL1ncQdJEIk7tgpcyJTX
         KAxkgK3bESdU8JjulSSxV+VTiLgkPA0tt1ib/scc3dVpeo275hu0xs2yrIm9t2ZGBNSv
         jxENqq/1TNAO9Y1K8sG8FEMNl6NB3rkpSFazvLfldXT+Tti4Jwqc09jTHqS9PW0TGq5P
         tk6dZhJxcqIxPduaR04Pk9vNbeA0dzPT6Hx3BpFlsKrHwXZfZixKZHwnB0NFNHU6Zge+
         Ki7A==
X-Gm-Message-State: APjAAAWNPvL3VnkP/TjXrnZPvOei+Xi9urIWpIlraqyx9ptM6Uxtju0m
        s3fqi2zFZ2MH5i1bXNRT/iFk3A==
X-Google-Smtp-Source: APXvYqwWZqxNag4/wYQckZ4ot60sd1xJndNWFAKPaGjjG4lMR3by1auZ9NFHfvmGV9Lq9nHyf/152A==
X-Received: by 2002:a37:983:: with SMTP id 125mr12748039qkj.411.1570754936223;
        Thu, 10 Oct 2019 17:48:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 56sm6415628qty.15.2019.10.10.17.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:48:56 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:48:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 00/17] ethtool netlink interface, part 1
Message-ID: <20191010174839.6e44158b@cakuba.netronome.com>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 22:59:00 +0200 (CEST), Michal Kubecek wrote:
> This is first part of netlink based alternative userspace interface for
> ethtool. It aims to address some long known issues with the ioctl
> interface, mainly lack of extensibility, raciness, limited error reporting
> and absence of notifications. The goal is to allow userspace ethtool
> utility to provide all features it currently does but without using the
> ioctl interface. However, some features provided by ethtool ioctl API will
> be available through other netlink interfaces (rtnetlink, devlink) if it's
> more appropriate.

Looks like perhaps with ETHTOOL_A_HEADER_RFLAGS checking taken out of
the picture we can proceed as is and potentially work on defining some
best practices around attrs and nesting for the future generations? :)

I was trying to find a way to perhaps start merging something.. Would
it make sense to spin out patches 1, 2, 3, and 8 as they seem to be
ready (possibly 11, too if the reorder isn't painful)?
