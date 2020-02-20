Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CF1663E9
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgBTRGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:06:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728618AbgBTRGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582218408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3M6kLg4BjF+DuWA5DcTOS8t/8X/cJ0Opg0BqCTy4sKU=;
        b=MBE6H7N6KAOUpDWGX3mzGHWn9ntHPYysErKiju0w1LpyWMl24rrXNppZVJHe7lhqAkDBbA
        4r2ajqMbxV3US10zQ8LjCa5Wusg+ATN7uPap33nUJgVOXgSi8kSMn1h9mVTRlLoaef0Uor
        VMJ+38u7lomJuWlEoJqS6ZEUagWgLtY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-Y7n3AiXIOXK816aJw8_wdQ-1; Thu, 20 Feb 2020 12:06:46 -0500
X-MC-Unique: Y7n3AiXIOXK816aJw8_wdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44F09100550E;
        Thu, 20 Feb 2020 17:06:42 +0000 (UTC)
Received: from redhatnow.users.ipa.redhat.com (ovpn-117-1.phx2.redhat.com [10.3.117.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2E0419756;
        Thu, 20 Feb 2020 17:06:32 +0000 (UTC)
Subject: Re: [RFC PATCH 04/11] cpufreq: Remove Calxeda driver
To:     Rob Herring <robh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-5-robh@kernel.org>
From:   Mark Langsdorf <mlangsdo@redhat.com>
Message-ID: <16a38b0d-8609-653a-64e8-3a0d4f4b1a45@redhat.com>
Date:   Thu, 20 Feb 2020 11:06:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218171321.30990-5-robh@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 11:13 AM, Rob Herring wrote:
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Acked-by: Mark Langsdorf <mark.langsdorf@gmail.com>

