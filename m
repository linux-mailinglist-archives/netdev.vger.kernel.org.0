Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA64E96B2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbiC1Mfa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Mar 2022 08:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiC1Mf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:35:26 -0400
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF14A634B;
        Mon, 28 Mar 2022 05:33:45 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id o5so25732740ybe.2;
        Mon, 28 Mar 2022 05:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=96R3YZlaxPkbqjS50KOs84E9IviQBiQAWcWza7S6bDo=;
        b=Eq2mSL2vnD6O8+ZRBdoVRBmAzgq1r6rWgZzq7LOOvHwzASWFDXpCszJbiVo012a9IS
         KrdQT5R31WmUNLZrAECQeCnBglVyWTUqKuJ43nw8AZ9VfDU2zZaUklkvR9BnM3S/v78E
         zUEVstpqnqhwc3lJonlMgYYtI1y0bew6v+5Nw08VU8nRs70VPZrmDlKjKP0DpLBs0biV
         He4quWuPDU9CqDdVp3couqESWsolz3fKT7Q4/1GulbgxBEjtg140XPxti9KW6lzk1UAI
         cpHx10t1/B7uG3mXCNP2ZxI2puZxYC58O+PR8RtoToBfa/oNEHrMarxQmK9uuTHRX7RS
         cjKA==
X-Gm-Message-State: AOAM533VjPY1pHRPQbGeOxrFqejjcPG0THMlugHn1enlAF/zPsUG+Z0U
        lfUN+mUAfBg7cWBQ9Ob/ZuwBDI9lKmWFZP8RKQM=
X-Google-Smtp-Source: ABdhPJx8Wg38N6VDkBqHhGiMOIVXRrg4vGvCYLhNlosUsWn6MZ6VqGYcxoBV2Rzxwr0C4NFzPtT0Oq2lDLGzpa8RiBA=
X-Received: by 2002:a25:9d8a:0:b0:633:9668:c48a with SMTP id
 v10-20020a259d8a000000b006339668c48amr23154148ybp.153.1648470824874; Mon, 28
 Mar 2022 05:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220326165909.506926-1-benni@stuerz.xyz> <20220326165909.506926-5-benni@stuerz.xyz>
In-Reply-To: <20220326165909.506926-5-benni@stuerz.xyz>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 28 Mar 2022 14:33:29 +0200
Message-ID: <CAJZ5v0iJ=t26mnxHx9B+_A3ue7tVjgATN=TTtNNf2UNfuySd7Q@mail.gmail.com>
Subject: Re: [PATCH 05/22] acpica: Replace comments with C99 initializers
To:     =?UTF-8?Q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux@simtec.co.uk, Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Moore <robert.moore@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, 3chas3@gmail.com,
        laforge@gnumonks.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        isdn@linux-pingi.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Nicolas Pitre <nico@fluxnic.net>,
        Loic Poulain <loic.poulain@linaro.org>, kvalo@kernel.org,
        pkshih@realtek.com, Bjorn Helgaas <bhelgaas@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
        linux-ia64@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        linux-atm-general@lists.sourceforge.net,
        netdev <netdev@vger.kernel.org>,
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        wcn36xx@lists.infradead.org,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 6:09 PM Benjamin Stürz <benni@stuerz.xyz> wrote:
>
> This replaces comments with C99's designated
> initializers because the kernel supports them now.

However, note that all of the ACPICA material should be submitted to
the upstream ACPICA project via https://github.com/acpica/acpica

Also please note that the set of compilers that need to be supported
by the ACPICA project is greater than the set of compilers that can
build the Linux kernel.


> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>  drivers/acpi/acpica/utdecode.c | 183 ++++++++++++++++-----------------
>  1 file changed, 90 insertions(+), 93 deletions(-)
>
> diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
> index bcd3871079d7..d19868d2ea46 100644
> --- a/drivers/acpi/acpica/utdecode.c
> +++ b/drivers/acpi/acpica/utdecode.c
> @@ -156,37 +156,37 @@ static const char acpi_gbl_bad_type[] = "UNDEFINED";
>  /* Printable names of the ACPI object types */
>
>  static const char *acpi_gbl_ns_type_names[] = {
> -       /* 00 */ "Untyped",
> -       /* 01 */ "Integer",
> -       /* 02 */ "String",
> -       /* 03 */ "Buffer",
> -       /* 04 */ "Package",
> -       /* 05 */ "FieldUnit",
> -       /* 06 */ "Device",
> -       /* 07 */ "Event",
> -       /* 08 */ "Method",
> -       /* 09 */ "Mutex",
> -       /* 10 */ "Region",
> -       /* 11 */ "Power",
> -       /* 12 */ "Processor",
> -       /* 13 */ "Thermal",
> -       /* 14 */ "BufferField",
> -       /* 15 */ "DdbHandle",
> -       /* 16 */ "DebugObject",
> -       /* 17 */ "RegionField",
> -       /* 18 */ "BankField",
> -       /* 19 */ "IndexField",
> -       /* 20 */ "Reference",
> -       /* 21 */ "Alias",
> -       /* 22 */ "MethodAlias",
> -       /* 23 */ "Notify",
> -       /* 24 */ "AddrHandler",
> -       /* 25 */ "ResourceDesc",
> -       /* 26 */ "ResourceFld",
> -       /* 27 */ "Scope",
> -       /* 28 */ "Extra",
> -       /* 29 */ "Data",
> -       /* 30 */ "Invalid"
> +       [0]  = "Untyped",
> +       [1]  = "Integer",
> +       [2]  = "String",
> +       [3]  = "Buffer",
> +       [4]  = "Package",
> +       [5]  = "FieldUnit",
> +       [6]  = "Device",
> +       [7]  = "Event",
> +       [8]  = "Method",
> +       [9]  = "Mutex",
> +       [10] = "Region",
> +       [11] = "Power",
> +       [12] = "Processor",
> +       [13] = "Thermal",
> +       [14] = "BufferField",
> +       [15] = "DdbHandle",
> +       [16] = "DebugObject",
> +       [17] = "RegionField",
> +       [18] = "BankField",
> +       [19] = "IndexField",
> +       [20] = "Reference",
> +       [21] = "Alias",
> +       [22] = "MethodAlias",
> +       [23] = "Notify",
> +       [24] = "AddrHandler",
> +       [25] = "ResourceDesc",
> +       [26] = "ResourceFld",
> +       [27] = "Scope",
> +       [28] = "Extra",
> +       [29] = "Data",
> +       [30] = "Invalid"
>  };
>
>  const char *acpi_ut_get_type_name(acpi_object_type type)
> @@ -284,22 +284,22 @@ const char *acpi_ut_get_node_name(void *object)
>  /* Printable names of object descriptor types */
>
>  static const char *acpi_gbl_desc_type_names[] = {
> -       /* 00 */ "Not a Descriptor",
> -       /* 01 */ "Cached Object",
> -       /* 02 */ "State-Generic",
> -       /* 03 */ "State-Update",
> -       /* 04 */ "State-Package",
> -       /* 05 */ "State-Control",
> -       /* 06 */ "State-RootParseScope",
> -       /* 07 */ "State-ParseScope",
> -       /* 08 */ "State-WalkScope",
> -       /* 09 */ "State-Result",
> -       /* 10 */ "State-Notify",
> -       /* 11 */ "State-Thread",
> -       /* 12 */ "Tree Walk State",
> -       /* 13 */ "Parse Tree Op",
> -       /* 14 */ "Operand Object",
> -       /* 15 */ "Namespace Node"
> +       [0]  = "Not a Descriptor",
> +       [1]  = "Cached Object",
> +       [2]  = "State-Generic",
> +       [3]  = "State-Update",
> +       [4]  = "State-Package",
> +       [5]  = "State-Control",
> +       [6]  = "State-RootParseScope",
> +       [7]  = "State-ParseScope",
> +       [8]  = "State-WalkScope",
> +       [9]  = "State-Result",
> +       [10] = "State-Notify",
> +       [11] = "State-Thread",
> +       [12] = "Tree Walk State",
> +       [13] = "Parse Tree Op",
> +       [14] = "Operand Object",
> +       [15] = "Namespace Node"
>  };
>
>  const char *acpi_ut_get_descriptor_name(void *object)
> @@ -331,13 +331,13 @@ const char *acpi_ut_get_descriptor_name(void *object)
>  /* Printable names of reference object sub-types */
>
>  static const char *acpi_gbl_ref_class_names[] = {
> -       /* 00 */ "Local",
> -       /* 01 */ "Argument",
> -       /* 02 */ "RefOf",
> -       /* 03 */ "Index",
> -       /* 04 */ "DdbHandle",
> -       /* 05 */ "Named Object",
> -       /* 06 */ "Debug"
> +       [0] = "Local",
> +       [1] = "Argument",
> +       [2] = "RefOf",
> +       [3] = "Index",
> +       [4] = "DdbHandle",
> +       [5] = "Named Object",
> +       [6] = "Debug"
>  };
>
>  const char *acpi_ut_get_reference_name(union acpi_operand_object *object)
> @@ -416,25 +416,22 @@ const char *acpi_ut_get_mutex_name(u32 mutex_id)
>  /* Names for Notify() values, used for debug output */
>
>  static const char *acpi_gbl_generic_notify[ACPI_GENERIC_NOTIFY_MAX + 1] = {
> -       /* 00 */ "Bus Check",
> -       /* 01 */ "Device Check",
> -       /* 02 */ "Device Wake",
> -       /* 03 */ "Eject Request",
> -       /* 04 */ "Device Check Light",
> -       /* 05 */ "Frequency Mismatch",
> -       /* 06 */ "Bus Mode Mismatch",
> -       /* 07 */ "Power Fault",
> -       /* 08 */ "Capabilities Check",
> -       /* 09 */ "Device PLD Check",
> -       /* 0A */ "Reserved",
> -       /* 0B */ "System Locality Update",
> -                                                               /* 0C */ "Reserved (was previously Shutdown Request)",
> -                                                               /* Reserved in ACPI 6.0 */
> -       /* 0D */ "System Resource Affinity Update",
> -                                                               /* 0E */ "Heterogeneous Memory Attributes Update",
> -                                                               /* ACPI 6.2 */
> -                                               /* 0F */ "Error Disconnect Recover"
> -                                               /* ACPI 6.3 */
> +       [0]  = "Bus Check",
> +       [1]  = "Device Check",
> +       [2]  = "Device Wake",
> +       [3]  = "Eject Request",
> +       [4]  = "Device Check Light",
> +       [5]  = "Frequency Mismatch",
> +       [6]  = "Bus Mode Mismatch",
> +       [7]  = "Power Fault",
> +       [8]  = "Capabilities Check",
> +       [9]  = "Device PLD Check",
> +       [10] = "Reserved",
> +       [11] = "System Locality Update",
> +       [12] = "Reserved (was previously Shutdown Request)",  /* Reserved in ACPI 6.0 */
> +       [13] = "System Resource Affinity Update",
> +       [14] = "Heterogeneous Memory Attributes Update",      /* ACPI 6.2 */
> +       [15] = "Error Disconnect Recover"                     /* ACPI 6.3 */
>  };
>
>  static const char *acpi_gbl_device_notify[5] = {
> @@ -521,26 +518,26 @@ const char *acpi_ut_get_notify_name(u32 notify_value, acpi_object_type type)
>   ******************************************************************************/
>
>  static const char *acpi_gbl_argument_type[20] = {
> -       /* 00 */ "Unknown ARGP",
> -       /* 01 */ "ByteData",
> -       /* 02 */ "ByteList",
> -       /* 03 */ "CharList",
> -       /* 04 */ "DataObject",
> -       /* 05 */ "DataObjectList",
> -       /* 06 */ "DWordData",
> -       /* 07 */ "FieldList",
> -       /* 08 */ "Name",
> -       /* 09 */ "NameString",
> -       /* 0A */ "ObjectList",
> -       /* 0B */ "PackageLength",
> -       /* 0C */ "SuperName",
> -       /* 0D */ "Target",
> -       /* 0E */ "TermArg",
> -       /* 0F */ "TermList",
> -       /* 10 */ "WordData",
> -       /* 11 */ "QWordData",
> -       /* 12 */ "SimpleName",
> -       /* 13 */ "NameOrRef"
> +       [0x00] = "Unknown ARGP",
> +       [0x01] = "ByteData",
> +       [0x02] = "ByteList",
> +       [0x03] = "CharList",
> +       [0x04] = "DataObject",
> +       [0x05] = "DataObjectList",
> +       [0x06] = "DWordData",
> +       [0x07] = "FieldList",
> +       [0x08] = "Name",
> +       [0x09] = "NameString",
> +       [0x0A] = "ObjectList",
> +       [0x0B] = "PackageLength",
> +       [0x0C] = "SuperName",
> +       [0x0D] = "Target",
> +       [0x0E] = "TermArg",
> +       [0x0F] = "TermList",
> +       [0x10] = "WordData",
> +       [0x11] = "QWordData",
> +       [0x12] = "SimpleName",
> +       [0x13] = "NameOrRef"
>  };
>
>  const char *acpi_ut_get_argument_type_name(u32 arg_type)
> --
> 2.35.1
>
