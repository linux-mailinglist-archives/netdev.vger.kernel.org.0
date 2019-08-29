Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD921A2AA7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfH2X1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:27:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40764 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2X1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:27:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so3182729pfn.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h1jVWHdrvbnk+HRvJ0bGKrgKPZiF/sGr+fA/wXTLTxc=;
        b=WJ3utls9nYaRg8mMrC4c2yYS8qx5hvq5fxF3cWqPG+E2uH+M2PzU01GilEhqsChsgJ
         q/9NnbzIqHk1H3wftA/VvHjRdgZm4KegqQuDkmdCAj+sg0IhBdJnTwB8GAOjTuJJWZY8
         wBoRSQzR6sPHdfOTnawam25LwqRSr86OHs+Lb/FsRueiL4Rqkm1Tez1mGSYrYANz/Mwj
         rm3KkEvANKXl0RkZodfI91SqUuVPXNlyHNQbCkny363JV1JohziKL6L36o83gIOW4nga
         rkmoeyVxutEpSM4JKsHg7BRFz5Jt7WiDzH8Gf7LXghFXCalRL8iZBiLsluH83ZWvoqdR
         mqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h1jVWHdrvbnk+HRvJ0bGKrgKPZiF/sGr+fA/wXTLTxc=;
        b=d2GT1OnD+Zrpn0I6uwtLEv2GrYDSPWA8fxWSFCG4FyHO+YUoPO9PKUikiKsJ1hvtyG
         IFPb21IId31QkPttF4K6unH+U7QiVDqV4A7HK7Pt3Ol5tiRDyzLjpuq0Rx1df6Un5l3G
         zK2YQ5a3t9fP62QxOK7iu988NyjgtEt7HtVhn1Miyc1QZch7qbHHoraW3VcDabX+2PMD
         khDIzQQyOcCg2gzBJb1MxHaNEpVIoR4Azx8J2veqzRv//8Oinh64eifmIW8hEHen1tcI
         enH5FEq6tm5pPo3VhJGxGRfawHToR4iVIVZk7ZAqqQlj+7eDEnuxRmoaGTQLd8c6j9fQ
         zdcw==
X-Gm-Message-State: APjAAAWGpMVsQVFsOfvVWQuMd+dKRWl+9HScvbT9P9MzECtKITdDq3yc
        1+Ce2DRvw79v1JpKtYCprQyckA==
X-Google-Smtp-Source: APXvYqz1L7yUB1XHTfVkDfZwkbYNIauvmn5XIA0Vy0jzOD7qcxcMAK04eLI9HvtDXvN75hbFqUfCcA==
X-Received: by 2002:a17:90a:f986:: with SMTP id cq6mr1311214pjb.48.1567121243649;
        Thu, 29 Aug 2019 16:27:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o35sm3081595pgm.29.2019.08.29.16.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:27:23 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:27:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [iproute2, master 2/2] devlink: Add a new time-stamp format for
 health reporter's dump
Message-ID: <20190829162722.6275fb02@hermes.lan>
In-Reply-To: <1566471942-28529-3-git-send-email-ayal@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
        <1566471942-28529-1-git-send-email-ayal@mellanox.com>
        <1566471942-28529-3-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 14:05:42 +0300
Aya Levin <ayal@mellanox.com> wrote:

> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index fc195cbd66f4..3f8532711315 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -348,6 +348,8 @@ enum devlink_attr {
>  	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
>  	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
>  
> +	DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TSPEC,
> +
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> -- 

Since this is not upstream, this patch needs to go to iproute2-next.
Which means if you want the other bug fix, send it again against master.
