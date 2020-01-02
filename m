Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461EB12E478
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgABJcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:32:35 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:37982 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgABJcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:32:35 -0500
Received: by mail-lj1-f182.google.com with SMTP id w1so18131893ljh.5
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 01:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q93m7pmOGAlonsbANxy87OAZmT+WblHiLAKKRagPLYY=;
        b=R5ABFf2hYw2oXwdfom2yAWfm3bKhEjMPhnhK1UqVNgGYxOE6UdL/Ln0mZBDSAdVQSF
         kad/D2eeyYiyEEHmm+vaWTjg5rvpyWCkkBOeUsfrFFvD+2GNH9lzE998KhszR1xHKQfi
         wi7/dAp0D0SaHTFXAjuFKuP/eHNb6tALF58s5LdUQpDmnRJiavlRWpr+7WtHhOJY+u8J
         5RLwmLQJIZwA0ytekW9SWfz+l1QozpUbeQzaBwsy88BXodR/AU4hCkUY0BuadAjHMgsz
         kWppk736cX6iH8Yauttc7lReubXONfkAHsbJ6Fr5EFot8Dw4LZ8Z6gDWAP3Kl4/FUnDs
         WuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q93m7pmOGAlonsbANxy87OAZmT+WblHiLAKKRagPLYY=;
        b=JJEbP4piF/247oeB2iKOt79YKkT20FYJyGfmheBqvgkq88jIeZNyutpHks4VhbOJXX
         v9Bg/obRb98IBxsJLGm5R1C0TIqGkC69/7IlEZq/jVkVU3It79hKlHP9C+PEqVsBegqC
         yPoWiHHraWCTkVjeqtTTXl0BqQe6Ly6dNMtNjvlkq4JaBLTP+/mtrN2s1EL4NVRpMDFQ
         S//3bvPTW3hdv77wEu9tCn6oQB7q5xSDKN8j3TIxre4PDChVtL1bxAa5d+EldmIaF3NV
         Mdimg0j7IaK7AU6XiWmBFotcy6j4bh6/++QSBBugCFwSGmaMOUBtlSU090Faid7Elmfy
         wKTA==
X-Gm-Message-State: APjAAAUFP2MavwDZsTNOne+Se7kAd50fXDUt9casqSkfrJUKQQeipUuT
        NdpGNajY3/7HtHUJpcgi4iDynja8CZFUkrLVN8s=
X-Google-Smtp-Source: APXvYqywZ6vfpuKhjzQ0r1G7OfdO5Lfi0J0//gOZEzdbGzPXaCACnkuKTN3KYzz9csWOAdi8hPkqhvatZxUopWL39z0=
X-Received: by 2002:a2e:b010:: with SMTP id y16mr49029247ljk.238.1577957552621;
 Thu, 02 Jan 2020 01:32:32 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNVLEEzAwCHZG_8D+CdWQRDRiTeL1N2zj1wQ0jh3vS67rA@mail.gmail.com>
 <CAJ3xEMiqf9-EP0CCAEhhnU3PnvdWpqSR8VbJa=2JFPiHAQwVcw@mail.gmail.com>
 <CAMDZJNXWG6jkNwub_nenx9FpKJB8PK7VTFj9wiUn+xM7-CfK3w@mail.gmail.com> <CAJ3xEMgXvxkmxNcfK-hFDWEu1qW7o7+FBhyGf3YGgr5dPK=Ddg@mail.gmail.com>
In-Reply-To: <CAJ3xEMgXvxkmxNcfK-hFDWEu1qW7o7+FBhyGf3YGgr5dPK=Ddg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 2 Jan 2020 17:31:56 +0800
Message-ID: <CAMDZJNVN8SuumcwOZZsgGDP-_-BX9K4sGC7-sbC3jypstrMXpQ@mail.gmail.com>
Subject: Re: mlx5e question about PF fwd packets to PF
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 2, 2020 at 3:50 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>
> On Thu, Jan 2, 2020 at 5:04 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>>
>> On Wed, Jan 1, 2020 at 4:40 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
>> > On Tue, Dec 31, 2019 at 10:39 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
>
>>
>> >> In one case, we want forward the packets from one PF to otter PF in eswitchdev mode.
>
>
>>
>> > Did you want to say from one uplink to the other uplink? -- this is not supported.
>
>
>>
>> yes, I try to install one rule and hope that one uplink can forward
>> the packets to other uplink of PF.
>
>
>
> this is not supported
>
>
>>
>> But the rule can be installed successfully, and the counter of rule is
>> changed as show below:
>
>
>>
>> # tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
>> flower action mirred egress redirect dev $PF1
>
>
> you didn't ask for skip_sw, if you install a rule with "none" and adding to hw
> fails, still the rule is fine in the SW data-path
>
>
>>
>> # tc -d -s filter show dev $PF0 ingress
>> filter protocol all pref 1 flower chain 0
>> filter protocol all pref 1 flower chain 0 handle 0x1
>>   in_hw
>
>
> this (in_hw) seems to be a bug, we don't support it AFAIK
>
>> action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>>   index 1 ref 1 bind 1 installed 19 sec used 0 sec
>>   Action statistics:
>> Sent 3206840 bytes 32723 pkt (dropped 0, overlimits 0 requeues 0)
>> backlog 0b 0p requeues 0
>
>
> I think newish (for about a year now or maybe more)  kernels and iproute have
> per data-path (SW/HW) rule traffic counters - this would help you realize what is
> going on down there
Hi, Or
Thanks for answering my question.
I add "skip_sw" option in tc command, and update the tc version to
upstream, it run successfully:
# tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1
flower skip_sw action mirred egress redirect dev $PF1
# tc -d -s filter show dev $PF0 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  skip_sw
  in_hw in_hw_count 1
action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
  index 1 ref 1 bind 1 installed 42 sec used 0 sec
  Action statistics:
Sent 408954 bytes 4173 pkt (dropped 0, overlimits 0 requeues 0)
Sent software 0 bytes 0 pkt
Sent hardware 408954 bytes 4173 pkt
backlog 0b 0p requeues 0

>>
>> The PF1 uplink don't sent the packets out(as you say, we don't support it now).
>> If we don't support it, should we return -NOSUPPORT when we install
>> the hairpin rule between
>> uplink of PF, because it makes me confuse.
>
>
> indeed, but only if you use skip_sw
>
> still the in_hw indication suggests there a driver bug
>
>
>>
>> > What we do support is the following (I think you do it by now):
>> > PF0.uplink --> esw --> PF0.VFx --> hairpin --> PF1.VFy --> esw --> PF1.uplink
>
>
>>
>> Yes, I have tested it, and it work fine for us.
>
>
> cool, so production can keep using these rules..
>
>
>>
>> > Hence the claim here is that if PF0.uplink --> hairpin --> PF1.uplink
>> > would have been supported
>
>
>>
>> Did we have plan to support that function.
>
>
> I don't think so, what is the need? something wrong with N+2 rules as I suggested?
N+2 works fine. I do some research about ovs offload with mellanox nic.
I add the uplink of PF0 and PF1 to ovs. and it can offload the
rule(PF0 to PF1, I reproduce with tc commands) to hardware but the nic
can't send the packet out.
>
>>
>> > and the system had N steering rules, with what is currently supported you
>> > need N+2 rules -- N rules + one T2 rule and one T3 rul
