Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158883AA4A2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhFPTxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:53:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhFPTxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=am0d0pk3jVy5OgKLNWHj2eNHd2bP49FJfF7PWRTv824=; b=FCCQNxZt/TF2vWt/xvxoq/bmqf
        RfptqKJtdguKsusQsWiDTSqJ05iQKq/2dat3cU5MzR6zoKBejU5g1y7Fa9oZZjDC+JjrkZfRY1ADI
        sZVrsSLjbdvUXcfByW93eg+5AJxjpNdj95ZeNAYFWwn+Y8I+rPGRNVJnUR2GxUi+9qtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltbZ1-009lrg-9W; Wed, 16 Jun 2021 21:51:03 +0200
Date:   Wed, 16 Jun 2021 21:51:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v2 5/7] net: mvmdio: add ACPI support
Message-ID: <YMpWJ79VF7HmjumQ@lunn.ch>
References: <20210616190759.2832033-1-mw@semihalf.com>
 <20210616190759.2832033-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616190759.2832033-6-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:07:57PM +0200, Marcin Wojtas wrote:
> This patch introducing ACPI support for the mvmdio driver by adding
> acpi_match_table with two entries:
> 
> * "MRVL0100" for the SMI operation
> * "MRVL0101" for the XSMI mode
> 
> Also clk enabling is skipped, because the tables do not contain
> such data and clock maintenance relies on the firmware.

This last part seems to be no longer true.

     Andrew
