Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA0A1B825D
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgDXXNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:13:40 -0400
Received: from bert.scottdial.com ([104.237.142.221]:50478 "EHLO
        bert.scottdial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXXNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:13:39 -0400
Received: from mail.scottdial.com (mail.scottdial.com [10.8.0.6])
        by bert.scottdial.com (Postfix) with ESMTP id 10A185718A1
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 19:13:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id A63BB1111605
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 19:13:38 -0400 (EDT)
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jEVl6ozQCrVK for <netdev@vger.kernel.org>;
        Fri, 24 Apr 2020 19:13:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.scottdial.com (Postfix) with ESMTP id C682D1111606
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 19:13:37 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.scottdial.com C682D1111606
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scottdial.com;
        s=24B7B964-7506-11E8-A7D6-CF6FBF8C6FCF; t=1587770017;
        bh=lzowNwOvUULw6pvOHyVMkiHO1T5Ku3XVhpiHjmgWS0k=;
        h=From:To:Message-ID:Date:MIME-Version;
        b=WaOph9GyZ7ncXrQDOhh2kPi/1EdbbMt7K36bTwPtF0AHrvpCfwORkXC9hTO8ZDXmG
         wW1HgaB/FcOOW463iG8Ieu5ZtUzRM6hj/af520vOonBNfkgpj4r4lSgEJw7Srl5wDn
         BAxCW5jawuQ40VwbQjgvINAfF8U7DMVncI2f/m0NISW6+JsrzDiu8d3ZeTFPPzX3lr
         lTyApCj54T2ZblYNP1H/mLWZARYoz82rTkKTtgSFX44oVjb5c67Yznis13tN8yYqt/
         Xauwa3Gt5dd08f8PnyUTWkXX/5PaDPDs5LMKOgkHbIy4M1m8ja1RKkVOlfgy/QrLw9
         x+mpgGGe1JYKA==
X-Virus-Scanned: amavisd-new at scottdial.com
Received: from mail.scottdial.com ([127.0.0.1])
        by localhost (mail.scottdial.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jWNHYGx1zJ1H for <netdev@vger.kernel.org>;
        Fri, 24 Apr 2020 19:13:37 -0400 (EDT)
Received: from [172.17.2.2] (unknown [172.17.2.2])
        by mail.scottdial.com (Postfix) with ESMTPSA id A0DDB1111605
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 19:13:37 -0400 (EDT)
Subject: Re: [PATCH net] net: macsec: fix ingress frame ordering
From:   Scott Dial <scott@scottdial.com>
To:     netdev@vger.kernel.org
References: <20200424223433.955775-1-scott@scottdial.com>
Message-ID: <cd9e5b77-0f17-b730-4feb-15098a2a2486@scottdial.com>
Date:   Fri, 24 Apr 2020 19:13:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424223433.955775-1-scott@scottdial.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, ignore this. I sent this patch twice by mistake.

-- 
Scott Dial
scott@scottdial.com
