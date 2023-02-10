Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB650691B39
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjBJJZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBJJZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:25:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA453CE2A;
        Fri, 10 Feb 2023 01:25:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38FE8B822F0;
        Fri, 10 Feb 2023 09:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9B5C433D2;
        Fri, 10 Feb 2023 09:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676021104;
        bh=g3Hvoh8XxmxV7sIMcWXMqq/DrLvN2leg00p9IvTmJFk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=NN6efVMz5K6iV8P3sEX9XassOxzc1gzPPqAhQzceej32Im7YVdluh1e0TKf+7KLKZ
         PgBstgJhCcip1ku2MacFlkxuhhfyOKMVXt6v2egHDuEMLvWE1XiP23sCHZSYYjmfI9
         U5kYdQO0op64wFj3VYt9iC4KYm27Sgg6Y1t9exflzXRfWXfu4ViYmb8AuvOVIXQlnK
         wdHidE24Lu8Ei2JRw6JqaZ3FCKLCj9YnKbNUUYPbylTmQvQpyhhMiSjVSj654ViDHO
         yaetFqtEhbdHuv2B4MNwWo/j3PyWU8CXgzRvyM4g5OuVb5LCjzXrnAfq5oESyS2lUd
         mgJzVWYXQZHow==
From:   Kalle Valo <kvalo@kernel.org>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, Jakub Kicinski <kuba@kernel.org>,
        Ajay.Kathat@microchip.com, Claudiu.Beznea@microchip.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amisha.Patel@microchip.com, Thomas Haller <thaller@redhat.com>,
        Beniamino Galvani <bgalvani@redhat.com>
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
In-Reply-To: <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
        (Heiko Thiery's message of "Fri, 10 Feb 2023 10:17:24 +0100")
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
        <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
        <20230209094825.49f59208@kernel.org>
        <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
        <20230209130725.0b04a424@kernel.org>
        <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
        <CAEyMn7bpwusVarzHa262maJHf6XTpCW4SL0-o+YH4DGZx94+hw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 10 Feb 2023 11:25:00 +0200
Message-ID: <87bkm1x47n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiko Thiery <heiko.thiery@gmail.com> writes:

> HI,
>
> Am Do., 9. Feb. 2023 um 22:19 Uhr schrieb Michael Walle <michael@walle.cc>:
>>
>> Am 2023-02-09 22:07, schrieb Jakub Kicinski:
>> > On Thu, 9 Feb 2023 18:51:58 +0000 Ajay.Kathat@microchip.com wrote:
>> >> > netdev should be created with a valid lladdr, is there something
>> >> > wifi-specific here that'd prevalent that? The canonical flow is
>> >> > to this before registering the netdev:
>> >>
>> >> Here it's the timing in wilc1000 by when the MAC address is available
>> >> to
>> >> read from NV. NV read is available in "mac_open" net_device_ops
>> >> instead
>> >> of bus probe function. I think, mostly the operations on netdev which
>> >> make use of mac address are performed after the "mac_open" (I may be
>> >> missing something).
>> >>
>> >> Does it make sense to assign a random address in probe and later read
>> >> back from NV in mac_open to make use of stored value?
>> >
>> > Hard to say, I'd suspect that may be even more confusing than
>> > starting with zeroes. There aren't any hard rules around the
>> > addresses AFAIK, but addrs are visible to user space. So user
>> > space will likely make assumptions based on the most commonly
>> > observed sequence (reading real addr at probe).
>>
>> Maybe we should also ask the NetworkManager guys. IMHO random
>> MAC address sounds bogus.
>
> Maybe it would be a "workaround" with loading the firmware while
> probing the device to set the real hw address.
>
> probe()
>   load_fw()
>   read_hw_addr_from_nv()
>   eth_hw_addr_set(ndev, addr)
>   unload_fw()
>
> mac_open()
>   load_fw()
>
> mac_close()
>   unload_fw()

This is exactly what many wireless drivers already do and I recommend
that wilc1000 would do the same.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
