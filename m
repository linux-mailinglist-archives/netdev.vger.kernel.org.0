Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6716D3326
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDASaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDASaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:30:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399461BF4C
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CybEhp7RyV+B9ga3DD1z6HprYG3wKyWRKNMWiB5PB0Q=; b=LGFyzxNsNWeW9sPclPRIhtC5ht
        AJI7q5NVtQkATrny8MbYyQcyygFRDx8+yPnsuLCjEuUovQIOSPZp22h9x0c33PviOPVoESXwNEyEz
        VCT0p03o5PT7r4IKXPKN46fadz7BSV9oIPtaHcDkLrhXOOtLHW8uNT3tdGw2ZN/CZWS0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pifz9-0099SI-2i; Sat, 01 Apr 2023 20:29:55 +0200
Date:   Sat, 1 Apr 2023 20:29:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Petr Oros <poros@redhat.com>
Subject: Re: [PATCH net-next 1/4] ice: lower CPU usage of the GNSS read thread
Message-ID: <d8de0d9c-6ccb-4fce-a954-177e6603cb46@lunn.ch>
References: <20230401172659.38508-1-mschmidt@redhat.com>
 <20230401172659.38508-2-mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401172659.38508-2-mschmidt@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 07:26:56PM +0200, Michal Schmidt wrote:
> The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox
> GNSS module, keep a CPU core almost 100% busy. The main reason is that
> it busy-waits for data to become available.

Hi Michal

Please could you change the patch subject. Maybe something like "Do
not busy wait in read" That gives a better idea what the patch does.

    Andrew
