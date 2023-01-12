Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF9F666C79
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbjALId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbjALIdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:33:49 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11F10065;
        Thu, 12 Jan 2023 00:33:47 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30C8XEtP1791566
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 08:33:16 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30C8X8q53803742
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 09:33:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673512389; bh=jU8aJlbo193snrPLtbyLKpWQuv3u8TMd2nglknjNFfI=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=kbFk+jvc0WJiJ2MWAIbY59qDIXCD+xoT8qJ79VXi6fe9Hy+riYGq8zWs0ZuEtIJFj
         ynmML9Es81rWDF7w9F6zABAxVPI5JEgMeENsHY0oG5wdjsYm5J755VIzGe9V+KXFPV
         jsXmqQh76PzdMRIUl4KCX1xv3oWKdCxe1I+ZF3/Q=
Received: (nullmailer pid 176378 invoked by uid 1000);
        Thu, 12 Jan 2023 08:33:08 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
Organization: m
References: <20230111133228.190801-1-andre.przywara@arm.com>
        <20230111213143.71f2ad7e@kernel.org>
Date:   Thu, 12 Jan 2023 09:33:08 +0100
In-Reply-To: <20230111213143.71f2ad7e@kernel.org> (Jakub Kicinski's message of
        "Wed, 11 Jan 2023 21:31:43 -0800")
Message-ID: <87k01s6tkr.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> On Wed, 11 Jan 2023 13:32:28 +0000 Andre Przywara wrote:
>> The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
>> Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
>> machines, Microsoft uses a custom USB device ID.
>>=20
>> Add the respective ID values to the driver. This makes Ethernet work on
>> the MS Devkit device. The chip has been visually confirmed to be a
>> RTL8153.
>
> Hm, we have a patch in net-next which reformats the entries:
> ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
>
> Would you like this ID to be also added in stable? We could just=20
> apply it to net, and deal with the conflict locally. But if you=20
> don't care about older kernels then better if you rebase.

And now I started worrying about consequences of that reformatting...
Maybe I didn't give this enough thought?

Please let me know if you prefer to have the old macro name back.  We
can avoid reformatting the list.


Bj=C3=B8rn
