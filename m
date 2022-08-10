Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D710F58F49C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 00:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiHJW7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 18:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiHJW7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 18:59:08 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0960367CA1;
        Wed, 10 Aug 2022 15:59:07 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w197so6443160oie.5;
        Wed, 10 Aug 2022 15:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MKXIoUEErA40N9CT/FYdo8YlhMi8ynVTChaHSFKe0nw=;
        b=Vyveb50Rr5C5XSEu/8tEoZ9xv3e6YMpXzhBqx1RGPYck19CmTWBonR07AHxwBwL1La
         CHDlBXIri27rMvSqDGtmqZil8BLa40kABlxrbjII+JwSaBqyH9lAQ6z+eB53f3/5/D/E
         7EeCWDc90XH2zV4c5bi7zMsxxERiQY1bs3r6xp7ne7WvO8YFlxoWZO1s1lxrE5WzIMIb
         /XVFQYyesv8WkyHoJfqae2dKVjMSX7TIit567XIKsup9LMhgiXNhf92zRSXtfdwlxnQa
         +MaKbaY5jkj+cSuKxsDoGmNZ0f0MJb0Aj38JImeQff0CLGumUYxM4+XMltw8xIvPT+cZ
         DVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MKXIoUEErA40N9CT/FYdo8YlhMi8ynVTChaHSFKe0nw=;
        b=gogV2mETt2kOnoYVictJDPs6Dx/4tT3xeApQTkcUZCnoRXWAXGJC1EdjAL1HZmcpnd
         IiRWwsGrA6S3IBocvt8LLEV1OTE2yjaMuM+k4i9kIJgWmgwHwCA0uE99L/UaTcuuK+Tt
         VvvC0x2BgeyRxAwH455a+RHRrHgXW5Kx4MFLKa/ySldXDFeruvZq+vugZ52MW7rIY0IF
         7cW+YCPXykofS8FwmhOWrbekMjM2WYYs2xDAvhfSfDjHXAc2zW8QPj5SLXtplZv/Vzdy
         HhHLgCgpj/Cq8QxI9Wp1WArLynK1XreNHz+2PhbwYi4IIc1DJySrIOJ73GWc97vsPzlX
         ABFw==
X-Gm-Message-State: ACgBeo1/+Q41IQ+QlB+/Va8elp9Bx4qWp3HECmbz85f+tt692XMaTqyM
        Rr9oDrhBb7U/wRnSFCCylFyXUXWygBdahc4i4SI=
X-Google-Smtp-Source: AA6agR42BlSqIS79o7TbKM4PqFFV7nJjel3wzJLO11XBfJNBRXhTQbXgbqMaL9G5GTEQe1dQzqCfwccpioSJ8+8zoEI=
X-Received: by 2002:a05:6808:bd6:b0:342:4683:32e7 with SMTP id
 o22-20020a0568080bd600b00342468332e7mr2336986oik.21.1660172346245; Wed, 10
 Aug 2022 15:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220805165850.50160-1-ecree@xilinx.com> <20220805184359.5c55ca0d@kernel.org>
 <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com> <20220808204135.040a4516@kernel.org>
 <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com> <20220810105811.6423f188@kernel.org>
 <cccb1511-3200-d5aa-8872-804f0d7f43a8@gmail.com>
In-Reply-To: <cccb1511-3200-d5aa-8872-804f0d7f43a8@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Aug 2022 15:58:54 -0700
Message-ID: <CAKgT0UdLFjxdxHTPb7c+Deih2Bciziz=gZxDYWUFsLNNetOFQg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, ecree@xilinx.com,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-net-drivers@amd.com, Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 12:21 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
>
> On 10/08/2022 18:58, Jakub Kicinski wrote:
> > On Wed, 10 Aug 2022 17:02:33 +0100 Edward Cree wrote:
> >> On 09/08/2022 04:41, Jakub Kicinski wrote:
> >>> I'd use "host PF", somehow that makes most sense to me.
> >>
> >> Not sure about that, I've seen "host" used as antonym of "SoC", so
> >>  if the device is configured with the SoC as the admin this could
> >>  confuse people.
> >
> > In the literal definition of the word "host" it is the entity which
> > "owns the place".
>
> Sure, but as an application of that, people talk about e.g. "host"
>  and "device" ends of a bus, DMA transfer, etc.  As a result of which
>  "host" has come to mean "computer; server; the big rack-mounted box
>  you plug cards into".
> A connotation which is unfortunate once a single device can live on
>  two separate PCIe hierarchies, connected to two computers each with
>  its own hostname, and the one which owns the device is the cluster
>  of embedded CPUs inside the card, rather than the big metal box.

I agree that "host" isn't going to work as a multi-host capable device
might end up having only one "host" that can actually handle the
configuration of the switch for the entire device. So then you have
different types of "host" interfaces.

> >> I think whatever term we settle on, this document might need to
> >>  have a 'Definitions' section to make it clear :S
> >
> > Ack, to perhaps clarify my concern further, I've seen the term
> > "management PF" refer to a PF which is not a netdev PF, it only
> > performs management functions.
>
> Yeah, I saw that interpretation as soon as you queried it.  I agree
>  we probably can't use "management PF".

One thing we may want to think about is looking more at "interfaces"
rather than "devices" or "functions". Essentially a PF is a "Host
Network Interface", a VF or sub-function would be a "Virtual Network
Interface", and an external port would be an "External/Uplink
Interface". Then we have a set of "interfaces" which would allow us to
get away from confusing networking and PCI bus topology where we also
have functions that are present on the device that may not expose
networking interfaces and provide control only. In addition something
like a VNI is more extensible so if we start getting into some other
new virtualization option in the future we are not stuck having to go
through and add yet more documentation to describe it all.

> > So a perfect term would describe the privilege
> > not the function (as the primary function of such PF should still
> > networking).
>
> I'm probably gonna get shot for suggesting this, but how about
>  "master PF"?

Usually with "master" you are talking about something like a bus. It
also occurs to me that the use of PF is assuming a single PCIe
function dedicated to performing this role. With sub-functions
floating around I could easily see a PF getting partitioned to
dedicate queues to handling switchdev operations while still allowing
other networking to pass over the original network interface. Then the
question is which one is the PF and which one is the subfunction.

I'd be more a fan of sticking with the "interface" naming and
describing what the interface would be used for. The first thought
that comes to mind is to just refer to the configuration interface as
a "NIC" since that would be the "Network Interface Controller",
however I could see how that could easily be confusing since that is
the PCI description for the device. Maybe something like a "Controller
Interface", "CI", would make sense since it seems like OVS uses
"Controller" to describe the instance that programs the flows, so we
could use similar terminology.
