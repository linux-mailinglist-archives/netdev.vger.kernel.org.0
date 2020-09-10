Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE832639B5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgIJCAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729865AbgIJBpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:45:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B0F21D7F;
        Thu, 10 Sep 2020 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599699942;
        bh=nkd040Ht4XkyAPmISsoDj1Nqmm2JMAPIvUTf0VzljnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ETeQByN+y2ZdmdbRc9d4TfwzusqQJuVhi0bCmr7EQ46lUUcaT3MIGy7ud/gzetKa
         4L8siXmyWXAzY7ff/OOFEDH5s4lQDGpop9gKBsSUG4BBbO5d8SooqRAiBbCucPlbA8
         vvuCqZU9Nb8kFEYhMI9+hVtWG31VeC5wBNPhb4eQ=
Date:   Wed, 9 Sep 2020 18:05:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v4 4/5] devlink: add support for overwrite mask to
 netdevsim
Message-ID: <20200909180540.50c88522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909222653.32994-5-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 15:26:52 -0700 Jacob Keller wrote:
> The devlink interface recently gained support for a new "overwrite mask"
> parameter that allows specifying how various sub-sections of a flash
> component are modified when updating.
> 
> Add support for this to netdevsim, to enable easily testing the
> interface. Make the allowed overwrite mask values controllable via
> a debugfs parameter. This enables testing a flow where the driver
> rejects an unsupportable overwrite mask.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

nit: subject should be prefixed with netdevsim: not devlink:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
