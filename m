Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15B5895B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF0R5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:57:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfF0R5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 13:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9RWG4ENVqbNHPWygNQrKHZ4t4O/w4lB9Os1ruL2W55s=; b=Hf3pUngcswkLufZiC4kscPXGa4
        wVOgU+VTVnIFqE7iHc59MsMx7YJ85rFLa5Gwxz9NMInPqan8BTfQQAYEKBkAgknd2227Vb+z1gSg7
        CZOA3XUrBf4ctsUvshwULTDLz/cyGZEXTAuyFqwafkrn9ifZiAd+3BYXNDbiv4HKdBfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgYe3-0002RC-JM; Thu, 27 Jun 2019 19:57:15 +0200
Date:   Thu, 27 Jun 2019 19:57:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bjking1@us.ibm.com, pradeep@us.ibm.com, dnbanerg@us.ibm.com
Subject: Re: [PATCH net] net/ibmvnic: Report last valid speed and duplex
 values to ethtool
Message-ID: <20190627175715.GP27733@lunn.ch>
References: <1561655353-17114-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561655353-17114-1-git-send-email-tlfalcon@linux.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 12:09:13PM -0500, Thomas Falcon wrote:
> This patch resolves an issue with sensitive bonding modes
> that require valid speed and duplex settings to function
> properly. Currently, the adapter will report that device
> speed and duplex is unknown if the communication link
> with firmware is unavailable.

Dumb question. If you cannot communicate with the firmware, isn't the
device FUBAR? So setting the LACP port to disabled is the correct
things to do.

       Andrew
