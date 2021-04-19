Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5139364D46
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDSVp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:45:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232382AbhDSVp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:45:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYbhl-00Hajm-FH; Mon, 19 Apr 2021 23:45:17 +0200
Date:   Mon, 19 Apr 2021 23:45:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        corbet@lwn.net, vladyslavt@nvidia.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: add missing EEPROM to list of messages
Message-ID: <YH357QLGqz6igLtc@lunn.ch>
References: <20210419212622.2993451-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419212622.2993451-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 02:26:22PM -0700, Jakub Kicinski wrote:
> ETHTOOL_MSG_MODULE_EEPROM_GET is missing from the list of messages.
> ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY is sadly a rather long name
> so we need to adjust column length.
> 
> Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/ethtool-netlink.rst | 70 ++++++++++----------
>  1 file changed, 36 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 48cad2fce147..c8814d787072 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -210,45 +210,47 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
>    ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
>    ``ETHTOOL_MSG_FEC_GET``               get FEC settings
>    ``ETHTOOL_MSG_FEC_SET``               set FEC settings
> +  ``ETHTOOL_MSG_MODULE_EEPROM_GET``	read SFP module EEPROM

It looks like you used a tab, where as the rest of the table is
spaces?

	Andrew
