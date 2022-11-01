Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B93C614BFB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiKANoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKANoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:44:01 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082372601;
        Tue,  1 Nov 2022 06:43:52 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y6so9325571iof.9;
        Tue, 01 Nov 2022 06:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OwHpbqKXJXUNg7FcCWBKaOWmya1OZFg3e8MV54SFrLw=;
        b=ixY/FAbapVim8KfwUPoI5hLK17fbz7x4cUOk2Ccbirl/RfSIizOsTnfj//YinOr0Px
         6oF4pBGFC/0mJm9oNyDipSOWIBwGaOySTtksW9QifttPT5hU1Ke6+Z2IWFg6uhqVtu84
         8VgT422XTYqlAT1Eg7qnW8YRT3mLB+MGIy7WUl6GBU5J1xc0XXWIjdv3/X0mFj9pGLDD
         yKFuV3VlFS4vGLMSB4IvOkXQHRVnHgxbf724wiRvE7HUco2c0ZO6sGBIaDJX0OwRXiNc
         gTy+rZkHODck40+TGv5SGUgBYF4ceiCfb/GyBm2cnXNimFGi0wM7zxMtGANnu7VoGcBi
         Rb9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwHpbqKXJXUNg7FcCWBKaOWmya1OZFg3e8MV54SFrLw=;
        b=xQs4thT0FV/Wk+qFwaZWqu22hI9b+ijqu7CSBGxComFoSvDvEzDaWLk4dRGbJRpzgr
         Y0JGYOMUp+2aNayk9F0nSFcnk8oH/QmHmRLwQOMaOQ0BiY1YAcO2EAER4fVzPXiZeA4C
         Vu1zlsMuBWGJMunqMhd0Z5IyzadNy6/fL3goR6HzRNwNYklVXxuCMGYvS38Up/VOldpM
         whiEw5t+q5xRTRRmwDMWfn9jlytzFkQ3Bi7bjZaiIjyUlFmB46RMClprgXDuI7Bvti2V
         nmAGfQF+vjH43I+6pdAdrWBuZXqUhjB4VvHXaBD8pPSlXcBktaUXdqnaQq2Ymlx34NUh
         gsNw==
X-Gm-Message-State: ACrzQf3dmX7qSovZTZ9jd/BaDeShXHex+CmlfeP0grfvdl/YgjgzxV2a
        RDlsH3PXjzqLdxfNO1mz23aBfmlUW60=
X-Google-Smtp-Source: AMsMyM7sOwxse8L8UWYCYPWWmDIGwKPHK6PeE93zvusl8sWtFl5MfjbfXk/dK1O+eVk7guEbG1mE+w==
X-Received: by 2002:a02:c994:0:b0:374:d09e:b599 with SMTP id b20-20020a02c994000000b00374d09eb599mr11671721jap.112.1667310232289;
        Tue, 01 Nov 2022 06:43:52 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:80e9:946e:f275:d401? ([2601:282:800:dc80:80e9:946e:f275:d401])
        by smtp.googlemail.com with ESMTPSA id m5-20020a056638260500b003755c84f596sm2216240jat.9.2022.11.01.06.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 06:43:50 -0700 (PDT)
Message-ID: <3caaaf96-58cf-9bf5-dcfe-2f6522f4da02@gmail.com>
Date:   Tue, 1 Nov 2022 07:43:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [xdp-hints] Re: [RFC bpf-next 0/5] xdp: hints via kfuncs
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "anatoly.burakov@intel.com" <anatoly.burakov@intel.com>,
        "song@kernel.org" <song@kernel.org>,
        "Deric, Nemanja" <nemanja.deric@siemens.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "willemb@google.com" <willemb@google.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "mtahhan@redhat.com" <mtahhan@redhat.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "haoluo@google.com" <haoluo@google.com>
References: <20221027200019.4106375-1-sdf@google.com>
 <635bfc1a7c351_256e2082f@john.notmuch> <20221028110457.0ba53d8b@kernel.org>
 <CAKH8qBshi5dkhqySXA-Rg66sfX0-eTtVYz1ymHfBxSE=Mt2duA@mail.gmail.com>
 <635c62c12652d_b1ba208d0@john.notmuch> <20221028181431.05173968@kernel.org>
 <5aeda7f6bb26b20cb74ef21ae9c28ac91d57fae6.camel@siemens.com>
 <875yg057x1.fsf@toke.dk>
 <CAKH8qBvQbgE=oSZoH4xiLJmqMSXApH-ufd-qEKGKD8=POfhrWQ@mail.gmail.com>
 <77b115a0-bbba-48eb-89bd-3078b5fb7eeb@linux.dev>
 <CAKH8qBsGB1G60cu91Au816gsB2zF8T0P-yDwxbTEOxX0TN3WgA@mail.gmail.com>
 <87wn8e4z14.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <87wn8e4z14.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/22 6:52 AM, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
> 
>> On Mon, Oct 31, 2022 at 3:57 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 10/31/22 10:00 AM, Stanislav Fomichev wrote:
>>>>> 2. AF_XDP programs won't be able to access the metadata without using a
>>>>> custom XDP program that calls the kfuncs and puts the data into the
>>>>> metadata area. We could solve this with some code in libxdp, though; if
>>>>> this code can be made generic enough (so it just dumps the available
>>>>> metadata functions from the running kernel at load time), it may be
>>>>> possible to make it generic enough that it will be forward-compatible
>>>>> with new versions of the kernel that add new fields, which should
>>>>> alleviate Florian's concern about keeping things in sync.
>>>>
>>>> Good point. I had to convert to a custom program to use the kfuncs :-(
>>>> But your suggestion sounds good; maybe libxdp can accept some extra
>>>> info about at which offset the user would like to place the metadata
>>>> and the library can generate the required bytecode?
>>>>
>>>>> 3. It will make it harder to consume the metadata when building SKBs. I
>>>>> think the CPUMAP and veth use cases are also quite important, and that
>>>>> we want metadata to be available for building SKBs in this path. Maybe
>>>>> this can be resolved by having a convenient kfunc for this that can be
>>>>> used for programs doing such redirects. E.g., you could just call
>>>>> xdp_copy_metadata_for_skb() before doing the bpf_redirect, and that
>>>>> would recursively expand into all the kfunc calls needed to extract the
>>>>> metadata supported by the SKB path?
>>>>
>>>> So this xdp_copy_metadata_for_skb will create a metadata layout that
>>>
>>> Can the xdp_copy_metadata_for_skb be written as a bpf prog itself?
>>> Not sure where is the best point to specify this prog though.  Somehow during
>>> bpf_xdp_redirect_map?
>>> or this prog belongs to the target cpumap and the xdp prog redirecting to this
>>> cpumap has to write the meta layout in a way that the cpumap is expecting?
>>
>> We're probably interested in triggering it from the places where xdp
>> frames can eventually be converted into skbs?
>> So for plain 'return XDP_PASS' and things like bpf_redirect/etc? (IOW,
>> anything that's not XDP_DROP / AF_XDP redirect).
>> We can probably make it magically work, and can generate
>> kernel-digestible metadata whenever data == data_meta, but the
>> question - should we?
>> (need to make sure we won't regress any existing cases that are not
>> relying on the metadata)
> 
> So I was thinking about whether we could have the kernel do this
> automatically, and concluded that this was probably not feasible in
> general, which is why I suggested the explicit helper. My reasoning was
> as follows:
> 
> For straight XDP_PASS in the driver we don't actually need to do
> anything today, as the driver itself will build the SKB and read any
> metadata it needs from the HW descriptor[0].

The program can pop encap headers, mpls tags, ... and thus affect the
metadata in the descriptor (besides the timestamp).

> 
> This leaves packets that are redirected (either to a veth or a cpumap so
> we build SKBs from them later); here the problem is that we buffer the
> packets (for performance reasons) so that the redirect doesn't actually
> happen until after the driver exits the NAPI loop. At which point we
> don't have access to the HW descriptors anymore, so we can't actually
> read the metadata.
> 
> This means that if we want to execute the metadata gathering
> automatically, we'd have to do it in xdp_do_redirect(). Which means that
> we'll have to figure out, at that point, whether the XDP frame is likely
> to be converted to an SKB. This will add at least one branch (and
> probably more) that will be in-path for every redirected frame.

or forwarded to a tun device as an xdp frame and wanting to pass
metadata into a VM which may construct an skb in the guest. This case is
arguably aligned with the redirect from vendor1 to vendor2.

This thread (and others) seem to be focused on the Rx path, but the Tx
path is equally important with similar needs.

