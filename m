Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97ACD5577C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfFYS7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:59:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40681 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfFYS7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:59:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so9337599pla.7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBtbcQGKGEQLSGTOTVSKsXXepAbvSbjrKAAjS5Cxenw=;
        b=L4W0rzsM6DsaHnj7xrJNX4t2NcE4gWLonUyWy4Ux1tDkHaA/DwlQU+6whg4qs+SGvH
         1QvjmXW/DSnX/USszsjpvslXxSbTNIujxOWrJH5pVq6DfEQiUFYUJMfLiVyz5EPKpaNn
         kUZF9FVMwaUPEyFZIUIcsUjoDdhiFHt/Ur6wF5FzLmLJdPGdrCwXunvx7V7dqNiiHXV/
         YS+fT8v6G12hfQgj9vkfSkgKwhIqgEk3EzTwt4n7hLxZmB0df/WxKJYpDZHNwVbTUtCi
         OOqIlF6T/qTvxCue+97neDBtRMDyJOzmvefMwtYRL+FmqfHPxUd63y2YhQSsPu4xtkf3
         5nIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBtbcQGKGEQLSGTOTVSKsXXepAbvSbjrKAAjS5Cxenw=;
        b=lqsX0bPoBR438IvEpAYzVtg6x8vpBJLXkgzFFhJqjyaJHJ2I4qHxUKNHe3LBPn4yg0
         9wL7s+ywECSvxmpUe8WDNW2NoToQYtTub0yVfIzpYxre8H3PkIK/LLk0u0iUT0H+La1u
         GVVXz5P9Z7nYXuxENzY4ex18OR2mBGWyOFO++T1GqKSU4HwOtk+i9lnSTUw9O+h09IfF
         9EEyC3Rfs9TQrKUD9/85S/x9RpXiC4G/llm3f20bewnVtBmODMQUTmEdAs2dzfpsz8pS
         2hrTJgtt7iHOw2yhBI8VBQ8+BCxZKAgT5wnuKYpILBVsOnw12Tl9l9gdkThhPtw8mUx5
         K5rg==
X-Gm-Message-State: APjAAAUBcEiVXh34qYQXyks5OLUAsAjJHFIkdp+7EpzTXyo7RMUSI+/g
        w6gE1xLUubKXZMqbtbxoJqURGA==
X-Google-Smtp-Source: APXvYqyftB+dGgM+lvxHAPxTSNceigLM1lGSAmCnNmn9rZfIrrBCDawnDumQ/57vRAVxzRSXmBPuHA==
X-Received: by 2002:a17:902:70c3:: with SMTP id l3mr241436plt.248.1561489158767;
        Tue, 25 Jun 2019 11:59:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s66sm4929939pgs.39.2019.06.25.11.59.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 11:59:18 -0700 (PDT)
Date:   Tue, 25 Jun 2019 11:59:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH iproute2 2/2] devlink: fix libc and kernel headers
 collision
Message-ID: <20190625115917.34827ebb@hermes.lan>
In-Reply-To: <7f81026b803edcaeaca05994298118271a2f287d.1561463345.git.baruch@tkos.co.il>
References: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
        <7f81026b803edcaeaca05994298118271a2f287d.1561463345.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 14:49:05 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> +/* Suppress linux/sysinfo.h to avoid
> + * collision of struct sysinfo definition
> + * with musl libc headers
> + */

You only need a small comment for this.

#define _LINUX_SYSINFO_H /* avoid collision with musl header */

