Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED4B3FA9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbfIPRki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 13:40:38 -0400
Received: from a6-195.smtp-out.eu-west-1.amazonses.com ([54.240.6.195]:60580
        "EHLO a6-195.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732173AbfIPRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 13:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=awgt3ic55kqhwizgro5hhdlz56bi7lbf; d=origamienergy.com;
        t=1568655635;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=GrvEXTmiY/Gfi5MF+9iwIL+fbGjhdyuMrvV+oMG4KZs=;
        b=RPn3QRXMj1MrNNESOGC6uwarzj3mr3jK0mV7/VWrxzE2UZCVTUGBPzs/ivTsK+ks
        blSxHjBEA9yyp1Tj+/ahzjqsYaXKgZt6qiTWlL0trvsjBvbuuU39gxzSVKEC0h/7xXm
        49armJ44uKiAJrA+g9e/bB3SasNavM72fx7GM4b4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1568655635;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=GrvEXTmiY/Gfi5MF+9iwIL+fbGjhdyuMrvV+oMG4KZs=;
        b=csROk06bIMVv5gn79rp/6gppI0PKR1qdMvnOomWzxpTLbZPdLmp/erBkFgOEkXrj
        6GZ19XGnbPFBmXcGJhcrO60JzgM8uJ9CHVewbTSnqYCJShPKA4GK3Y6mDpnZU2FRf7/
        pt6xD25UOuchhQo6hkDqAtvvhUGc4HI5G5dL+n7g=
Subject: Re: [PATCH] dt-bindings: net: Correct the documentation of KSZ9021
 skew values
To:     David Miller <davem@davemloft.net>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <0102016d2b84f180-bd396cb9-16cf-4472-b718-7a4d2d8d8017-000000@eu-west-1.amazonses.com>
 <20190916.161455.1015414751228915954.davem@davemloft.net>
From:   James Byrne <james.byrne@origamienergy.com>
Message-ID: <0102016d3b297538-fcca5199-6ad1-4625-b11c-3ad3919a0c48-000000@eu-west-1.amazonses.com>
Date:   Mon, 16 Sep 2019 17:40:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190916.161455.1015414751228915954.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2019.09.16-54.240.6.195
Feedback-ID: 1.eu-west-1.sQ65CuNSNkrvjFrT7j7oeWmhxZgivYoP5c3BHSC7Qc8=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/09/2019 15:14, David Miller wrote:
> From: James Byrne <james.byrne@origamienergy.com>
> Date: Fri, 13 Sep 2019 16:46:35 +0000
> 
>> The documentation of skew values for the KSZ9021 PHY was misleading
>> because the driver implementation followed the erroneous information
>> given in the original KSZ9021 datasheet before it was corrected in
>> revision 1.2 (Feb 2014). It is probably too late to correct the driver
>> now because of the many existing device trees, so instead this just
>> corrects the documentation to explain that what you actually get is not
>> what you might think when looking at the device tree.
>>
>> Signed-off-by: James Byrne <james.byrne@origamienergy.com>
> 
> What tree should this go into?

I believe this should go into the 'net' tree, but please let me know if 
I have submitted this patch incorrectly in some way.

James
