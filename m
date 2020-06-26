Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F72820B8E0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgFZS67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFZS67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 14:58:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 884512053B;
        Fri, 26 Jun 2020 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593197938;
        bh=y9VJxGXkCkgdn9hB023P9vduEo7KgI1GLcMOItbxN3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AB8e8/Gew/GEKyHpYQcFS4Plsq0zTbTMIkPkyEY1eruutGpySDP7SFyoPaYpvlS8c
         /e/VP6rWTN9XOwo+gKAvTTLXp7YqreA65sLD+o9iPq43DngogHJeq108fa5zshJBG0
         yta8zrqGuh5mtEkCJHH1Ki6PC58Ja6OPD1XLAgsw=
Date:   Fri, 26 Jun 2020 11:58:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v3 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-06-25
Message-ID: <20200626115856.6288b63e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:22 -0700 Jeff Kirsher wrote:
> This series introduces both the Intel Ethernet Common Module and the Intel
> Data Plane Function.  The patches also incorporate extended features and
> functionality added in the virtchnl.h file.
>  
> The format of the series flow is to add the data set, then introduce
> function stubs and finally introduce pieces in large cohesive subjects or
> functionality.  This is to allow for more in depth understanding and
> review of the bigger picture as the series is reviewed.
> 
> Currently this is common layer (iecm) is initially only being used by only
> the idpf driver (PF driver for SmartNIC).  However, the plan is to
> eventually switch our iavf driver along with future drivers to use this
> common module.  The hope is to better enable code sharing going forward as
> well as support other developers writing drivers for our hardware

Honestly you can as well squash most of these patches together.

The way they are split actually makes the reviewing harder not easier.
