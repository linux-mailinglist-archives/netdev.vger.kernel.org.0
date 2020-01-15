Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E413CB7D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAOR5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:57:35 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:49568 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAOR5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:57:34 -0500
Received: from [192.168.1.47] (unknown [50.34.171.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 24B5613C35F
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 09:57:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 24B5613C35F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579111052;
        bh=PXSXAC6+hnExK6k3oFCEjWelEP7S60+6LXjn6c7Wt3w=;
        h=To:From:Subject:Date:From;
        b=Tv3NTLrEegzV7VfWX6W5k08gUP8BO+QRfFilhLOHzBdRDq5EamzR2hReYyiozqtRa
         +TW9a0bRZNOg+S57iuGjpeS3P51hT+w7NTlwZfJm9F8s/6YHpZC+k9wVYERSqtoazL
         YxjRaX4YVnnyFLoZteff1zgDxPg2nCYkMtD+zfes=
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: vrf and multicast is broken in some cases
Message-ID: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
Date:   Wed, 15 Jan 2020 09:57:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We put two different ports into their own VRF, and then tried to run a multicast
sender on one and receiver on the other.  The receiver does not receive anything.

Is this a known problem?

If we do a similar setup with policy based routing rules instead of VRF, then the multicast
test works.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
