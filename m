Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0401F2BC2A8
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgKUXjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgKUXjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:39:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83F4920A8B;
        Sat, 21 Nov 2020 23:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606001947;
        bh=ILrDABQfxNpfEZyYWxMiimFYJtYQrT6soJjxwPWQgZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SgfRMie1eVYoirHKeaE/LUpQcOicJnYu6xq936hSJkpy2p+rUnfA8AB4mwpeeMldB
         27pgil7IUgLRJvjuuD7sWTqNxe4NV4UDbt3W3GmgeNGTTRAFFdblVnRZ7EIf8tPH5/
         kPUjXE6yoxu+E5n4kTT7hALJ4fltQy470fZq0Vds=
Date:   Sat, 21 Nov 2020 15:39:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 04/15] ibmvnic: remove free_all_rwi function
Message-ID: <20201121153906.50ddce52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120224049.46933-5-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-5-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:40:38 -0600 Lijun Pan wrote:
> From: Dany Madden <drt@linux.ibm.com>
> 
> Remove free_all_rwi() since it is no longer used. (__ibmvnic_remove() was
> the last user of free_all_rwi()).

Squash this with the appropriate change, please.
