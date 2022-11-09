Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0972623750
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiKIXLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiKIXLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:11:16 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0C31F86;
        Wed,  9 Nov 2022 15:11:01 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id o4so28112464wrq.6;
        Wed, 09 Nov 2022 15:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r9iWguWns0x9A7Db/eP4sWbuE7/7/Te9Q5CWCVNExi4=;
        b=Mp/JfrVt/MX77ZGRh9Ylnl7eRKBtvjjN9bnK97ag1TAQOd7126qRYh9Vmex58AQHCd
         RHb917ewG/l3y+LluFupjKrYo9ziFyes+ZBFGI6B6ek94SO7OXLmAmbl9jLYsdUNuSMn
         BAVec6/SzlqIhSTVCmvFojKfaKmS9tWceWEqAZiqdvR1bWZVZo0gLXgWFmZW11Z7YWfE
         IzW9RSxb0IG5KU1x+52n9J2lreZMlshaqPLA7LsdvJbeRB8Teq+BDetmQ4YJhhKacjVf
         x9xxypP3ZUBBEP49ToGgRvSxfsnQ/NvqQwa+5dcOX4heTxphOeT4mOBOIFQbO+JTFwXb
         NGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9iWguWns0x9A7Db/eP4sWbuE7/7/Te9Q5CWCVNExi4=;
        b=3jwdThbwYLku4EVaTV8p/vYjYw7v7MGL6taVeDS7SKqR0CJz7NOwOqQJnByxrnT993
         Y2y6aaJqznbi6RazpN6Wi/cD7GrrHgU9cEOe5F90D1iOaYkwb03q3HND8mHXU3fKZGYl
         dFJnFs4JnaG1IbcpD1EFxmMAcn62qIvxTO7S12Cu4d+uTjaPQUGrxZd+mEkWoOIgFrR7
         D0lvRqjAE/Byb9VdJvCVITreflGJb/VXSxzLXcjhlIHEDYspmIKPZmMOX7U8vadnevIf
         dllk+j1qRk7UA5E90w1Pvevszy0j0dWYczrry2eIbNa1oCH35B2dSzd9FYEZffN6040P
         1RvA==
X-Gm-Message-State: ACrzQf3ZVTmANdOiN3kRz9a7h14a9Me0zJv0HcN/AS7uC/pS/cPMf9LH
        GlNkQmrM/PxUrEKK5thZcpM=
X-Google-Smtp-Source: AMsMyM7Efp2B9p5lVNUTqeUeoSbdshuGBnf/t1RYqbLTUKoRoqG4sbrUv4Z0/p4fqqdSpPH4VkHLUQ==
X-Received: by 2002:a5d:4d03:0:b0:236:b317:fcf6 with SMTP id z3-20020a5d4d03000000b00236b317fcf6mr38281005wrt.280.1668035460420;
        Wed, 09 Nov 2022 15:11:00 -0800 (PST)
Received: from 168.52.45.77 (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id p33-20020a05600c1da100b003c71358a42dsm3849658wms.18.2022.11.09.15.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 15:10:59 -0800 (PST)
Message-ID: <7ef5b6a3-affb-5298-9a13-c416d5e55ad4@gmail.com>
Date:   Thu, 10 Nov 2022 00:10:56 +0100
MIME-Version: 1.0
User-Agent: nano 6.4
Subject: Re: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users
 disable the fake CSR force-suspend hack
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, luiz.von.dentz@intel.com,
        quic_zijuhu@quicinc.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Jack <ostroffjh@users.sourceforge.net>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20221029202454.25651-1-swyterzone@gmail.com>
 <20221029202454.25651-3-swyterzone@gmail.com>
 <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com>
 <ac1d556f-fe51-1644-0e49-f7b8cf628969@gmail.com>
 <CABBYNZJytVc8=A0_33EFRS_pMG6aUKnfFPsGii_2uKu7_zENtQ@mail.gmail.com>
From:   Swyter <swyterzone@gmail.com>
In-Reply-To: <CABBYNZJytVc8=A0_33EFRS_pMG6aUKnfFPsGii_2uKu7_zENtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_HELO_IP_MISMATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 23:39, Luiz Augusto von Dentz wrote:
>>> Is this specific to Barrot 8041a02? Why don't we add a quirk then?
>>>
>>
>> We don't know how specific it is, we suspect the getting stuck thing happens with Barrot controllers,
>> but in this world of lasered-out counterfeit chip IDs you can never be sure. Unless someone decaps them.
>>
>> Hans added that name because it's the closest thing we have, but this applies to a lot of chips.
>> So much that now we do the hack by default, for very good reasons.
>>
>> So please reconsider, this closes the gap.
>>
>> With this last patch we go from ~+90% to almost ~100%, as the rest of generic quirks we added
>> don't really hurt; even if a particular dongle only needs a few of the zoo of quirks we set,
>> it's alright if we vaccinate them against all of these, except some are "allergic"
>> against this particular "vaccine". Let people skip this one. :-)
>>
>> You know how normal BT controllers are utterly and inconsistently broken, now imagine you have a whole host
>> of vendors reusing a VID/PID/version/subversion, masking as a CSR for bizarre reasons to avoid paying
>> any USB-IF fees, or whatever. That's what we are fighting against here.
> 
> I see, but for suspend in particular, can't we actually handle it
> somehow? I mean if we can detect the controller is getting stuck and
> print some information and flip the quirk? Otherwise Im afraid this
> parameter will end up always being set by distros to avoid suspend
> problems.

Maybe, auto-detection is certainly a better way and a potential improvement,
assuming we cover all the edge cases. Which I'm not too sure about.

The controllers don't get totally stuck, they just act weird and give funky
HCI responses at certain points if we don't do this, if I remember correctly.

Unfortunately I can't really justify spending that much time *right now* on
this hobby project. Distros should *definitely* keep doing the hack by default
if they want the widest compatibility. This is comparatively a niche issue.


But yeah, to sum things up; I'm not sure going back to a whitelist of a
whitelist is a good idea without a foolproof method. We want the widest
possible reach by doing it in the most generic way with the smallest
possible side effects. If we can find a way to blacklist this quirk
when we are super sure it's going to cause issues I'm all for it.

Right now I think this is an acceptable solution, as long as
people in charge of distros don't flip these toggles.

Nobody has cared until now, barely any of these devices worked.
Now that most of them work it would be very funny to see
them break the majority to fix a few.

With the amount of effort it takes an outsider like me to
get stuff into the kernel and fight to avoid random reverts
I don't know if I'd be able to get something as involved as
that to work in a satisfying, automatic and simple way.

Perfect is the enemy of good, diminishing returns, and all that. ¯\_(ツ)_/¯
