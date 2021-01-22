Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C511300B6F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbhAVSWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:22:10 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:34210 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbhAVPqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:46:17 -0500
Received: from [192.168.254.6] (unknown [50.34.179.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 601AE13C2B3;
        Fri, 22 Jan 2021 07:45:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 601AE13C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1611330330;
        bh=oeu5lyr9a0/9AMnp7pxS9/zEjejHT5tC9kjZO6TgyuE=;
        h=To:From:Subject:Date:From;
        b=K9lA2StF2LvFo9dD3GwvaM0NkugaAqcQANL2r877KqJKIZggd7qxhyauIwFm2/MuA
         4u3KohEi9OySfhqjSwlfesXEDIK+yVToF1hxZgvOTmYZvfWt52N9wvozoquCdW3Duj
         l3bK+Z31jkbDaWdTyd4PrTLgxX2B+Kz6EyKaUqQY=
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: VRF: ssh port forwarding between non-vrf and vrf interface.
Organization: Candela Technologies
Message-ID: <7dcd75bb-b934-e482-2e84-740c5c80efe0@candelatech.com>
Date:   Fri, 22 Jan 2021 07:45:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have a system with a management interface that is not in any VRF, and then I have
a port that *is* in a VRF.  I'd like to be able to set up ssh port forwarding so that
when I log into the system on the management interface it will automatically forward to
an IP accessible through the VRF interface.

Is there a way to do such a thing?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
