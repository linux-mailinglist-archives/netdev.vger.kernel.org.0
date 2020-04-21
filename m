Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251C71B2FD8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgDUTMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:12:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDUTMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IJIJtX44kNH+McJ2JiITCQ1W1kz6JwwWEuCA2rHNl6Y=; b=QtNy3aB/4bpodlLWyZSryfVl6z
        qFUx7fhostNm7eXDKGl2rA9JuYo3yWLm1Y0FdCjiLk1K9tyKAXX+GpMAvSQmGsCnTMqiZ8gE3m9q6
        ukXuD3bmWt51fYDGZqfAmUE4FRcd0E3jsjmUIwxVjl+Sw5K5ybMYmWMQD4sVUraEx9l8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQyJp-0044kv-0d; Tue, 21 Apr 2020 21:12:29 +0200
Date:   Tue, 21 Apr 2020 21:12:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Jack Ping CHNG <jack.ping.chng@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>
Subject: Re: [net-next 1/1] gwdpa: gswip: Introduce Gigabit Ethernet Switch
 (GSWIP) device driver
Message-ID: <20200421191229.GH933345@lunn.ch>
References: <20200421032202.3293500-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421032202.3293500-1-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 08:22:02PM -0700, Jeff Kirsher wrote:
> From: Jack Ping CHNG <jack.ping.chng@linux.intel.com>
> 
> This driver enables the Intel's LGM SoC GSWIP block. GSWIP is a core module
> tailored for L2/L3/L4+ data plane and QoS functions. It allows CPUs and
> other accelerators connected to the SoC datapath to enqueue and dequeue
> packets through DMAs. Most configuration values are stored in tables
> such as Parsing and Classification Engine tables, Buffer Manager tables
> and Pseudo MAC tables.

I don't find any netdev calls in this. No alloc_netdev or
register_netdev. How are you supposed to use this code?

The device tree binding documentation is missing.

There are also a number of inline functions.

Has this code been reviewed by the usual Intel Open Source Technology
people? GregKH kept pushing for this code to go through those people
so that the code gets a good internal review and fixed up before it is
posted yet again.

       Andrew
