Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CDE123025
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfLQPXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:23:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45987 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfLQPXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:23:13 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so7543643wrj.12;
        Tue, 17 Dec 2019 07:23:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4jMnvXlfIXqQVWBPxG/mv/FYRxV3EXzFNkPvP/otuwo=;
        b=i4FyNmu+xVs9SL4lEzjKcinpWtyFIuOClFDg4W77SSoc/XwshcnbeVK5oU0dcT4mHT
         cVnW+uiXPWEN2omfIUSZOY80VpT8Xv/C4II9/7N01GdPtEIZ1am7T0UGA2Xiw0mU+EfK
         5dsWpdHhIVdOAvmyLZS2sYHCwnTAQRPs7FVCUOZFYV9SHHb0Gn2k0IQp96bKr+4fLRUm
         UiDzCyDc7vjHrg3PniIiJ0Nam8ivDDqko58EPzDnCb6V/B9W9PfXt7x5uxAhARGou6Mi
         lUDu1qZ8m04ks5tQcxI4gL3A7Vzj1hBNghzoFE1VlAuxAsfay9CC/Yrr0e/qpeYvLtLa
         saTA==
X-Gm-Message-State: APjAAAWilaNXRmkrUA3/UFpvWhx5oukZgyjlrIEAEBFPvHh/lk84Utgv
        doHtRdK9UAmlMPGdTvAl0/o=
X-Google-Smtp-Source: APXvYqxLCJoIoEP3yDRqDS5GKQ5fAd8g8r5iVYPeQXUur37Rc/QTN29MW8nDmGk2hEaRP6pH4/wVzw==
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr36621601wrt.70.1576596192107;
        Tue, 17 Dec 2019 07:23:12 -0800 (PST)
Received: from debian (38.163.200.146.dyn.plus.net. [146.200.163.38])
        by smtp.gmail.com with ESMTPSA id m126sm3338168wmf.7.2019.12.17.07.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:23:11 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:23:09 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/3] xen-netback: move netback_probe() and
 netback_remove() to the end...
Message-ID: <20191217152309.inhyugu2fymmnvus@debian>
References: <20191217133218.27085-1-pdurrant@amazon.com>
 <20191217133218.27085-2-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217133218.27085-2-pdurrant@amazon.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:32:16PM +0000, Paul Durrant wrote:
> ...of xenbus.c
> 
> This is a cosmetic function re-ordering to reduce churn in a subsequent
> patch. Some style fix-up was done to make checkpatch.pl happier.
> 
> No functional change.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
