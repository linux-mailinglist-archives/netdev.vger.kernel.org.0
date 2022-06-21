Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA31552F0C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349496AbiFUJqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348999AbiFUJqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:46:06 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DB6427CDC;
        Tue, 21 Jun 2022 02:46:02 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AE8C165C;
        Tue, 21 Jun 2022 02:46:02 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3243A3F5A1;
        Tue, 21 Jun 2022 02:45:59 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:45:56 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Sudeep Holla <sudeep.holla@arm.com>,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <20220621094556.5ev3nencnw7a5xwv@bogus>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-10-mw@semihalf.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> Describe the Distributed Switch Architecture (DSA) - compliant
> MDIO devices. In ACPI world they are represented as children
> of the MDIO busses, which are responsible for their enumeration
> based on the standard _ADR fields and description in _DSD objects
> under device properties UUID [1].
> 
> [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  Documentation/firmware-guide/acpi/dsd/dsa.rst | 359 ++++++++++++++++++++
>  Documentation/firmware-guide/acpi/index.rst   |   1 +
>  2 files changed, 360 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/dsa.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/dsa.rst b/Documentation/firmware-guide/acpi/dsd/dsa.rst
> new file mode 100644
> index 000000000000..dba76d89f4e6
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/dsa.rst

Why is this document part of Linux code base ?
How will the other OSes be aware of this ?
I assume there was some repository to maintain such DSDs so that it
is accessible for other OSes. I am not agreeing or disagreeing on the
change itself, but I am concerned about this present in the kernel
code.

--
Regards,
Sudeep
