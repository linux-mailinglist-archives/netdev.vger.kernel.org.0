Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27338230BFF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 16:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgG1OE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 10:04:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgG1OE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 10:04:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0QDt-007HyX-2D; Tue, 28 Jul 2020 16:04:53 +0200
Date:   Tue, 28 Jul 2020 16:04:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 1/2] mlxsw: core: Add ethtool support for
 QSFP-DD transceivers
Message-ID: <20200728140453.GF1705504@lunn.ch>
References: <20200728102016.1960193-1-idosch@idosch.org>
 <20200728102016.1960193-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728102016.1960193-2-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:20:15PM +0300, Ido Schimmel wrote:
> From: Vadim Pasternak <vadimp@mellanox.com>
> 
> The Quad Small Form Factor Pluggable Double Density (QSFP-DD) hardware
> specification defines a form factor that supports up to 400 Gbps in
> aggregate over an 8x50-Gbps electrical interface. The QSFP-DD supports
> both optical and copper interfaces.
> 
> Implementation is based on Common Management Interface Specification;
> Rev 4.0 May 8, 2019. Table 8-2 "Identifier and Status Summary (Lower
> Page)" from this spec defines "Id and Status" fields located at offsets
> 00h - 02h. Bit 2 at offset 02h ("Flat_mem") specifies QSFP EEPROM memory
> mode, which could be "upper memory flat" or "paged". Flat memory mode is
> coded "1", and indicates that only page 00h is implemented in EEPROM.
> Paged memory is coded "0" and indicates that pages 00h, 01h, 02h, 10h
> and 11h are implemented. Pages 10h and 11h are currently not supported
> by the driver.
> 
> "Flat" memory mode is used for the passive copper transceivers. For this
> type only page 00h (256 bytes) is available. "Paged" memory is used for
> the optical transceivers. For this type pages 00h (256 bytes), 01h (128
> bytes) and 02h (128 bytes) are available. Upper page 01h contains static
> advertising field, while upper page 02h contains the module-defined
> thresholds and lane-specific monitors.
> 
> Extend enumerator 'mlxsw_reg_mcia_eeprom_module_info_id' with additional
> field 'MLXSW_REG_MCIA_EEPROM_MODULE_INFO_TYPE_ID'. This field is used to
> indicate for QSFP-DD transceiver type which memory mode is to be used.
> 
> Expose 256 bytes buffer for QSFP-DD passive copper transceiver and
> 512 bytes buffer for optical.
> 
> Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
