Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D6422981C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgGVMSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731815AbgGVMSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 08:18:00 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F94C0619DF
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:18:00 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q2so1674087qkc.8
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 05:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9BLR65N0DK1WAQMfwhXDmyYdZtIuFhu+7sSKbnFmGBg=;
        b=CnSJjYRYgqBKnxAhOoaJ73NC/11jUXO2fnXl8A5srULkyc23EdpfH6Ag4Q7sCpj6gi
         I/ylHYX+iAernqvFYDNpMCrKakL7VTYKqHvxJWoDFr+D/1L5rWLCOwe7+woNil+p1DxE
         0mIi1dlKiESkZbULrUqwdlH0PUen1RETVPqbXF3Q2MbNKoZTOGuEeuAyEh0k7l5mqSeZ
         PRylw9vf8GZVNTVhymFrGwiHHwcWBFTc+J+zEghe8A4ptqw0EIw382NX6n+HUMoBsFZ9
         19bKmdWmFrngTHa+5kCXS7OIJdUXbp432jrGvChPy/4ZHYEYT/ViUz20hH89eM281slH
         +brQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9BLR65N0DK1WAQMfwhXDmyYdZtIuFhu+7sSKbnFmGBg=;
        b=QYKkSdO9ucj9Dlxp3bUtWvtrMA9aFkmPnk9ANR0B8y1QGWfrrPfXv6TFVeZr4htm6k
         Purnj1yw6OIur8fg2yQJYhwW19TEj9BMIwrbya7RhrO5Tza2+8Zj/4VUiO5ltikBDq/C
         f+zOZap5/IHhDl5Rpolfn22Bygm92UCyKa0BQcz3+csqlIRJIyNDsyf5EHYE519MyMaz
         ef1xQfHXcr+BkYYAhiJKM/PisQhCi3JDlAZ0SMI3ZyeZShFUhNM3MhtlBekKth5rsq32
         CZCLHnD6GR+Ae3y/ObMTvgi3y22fvLJzq8pXcJ/CJYR2/gRXO5hWrN+Ua/u9JBXTC8TN
         4gLg==
X-Gm-Message-State: AOAM531IndA+8sKrbJgLzOLm+epIgvAYNkTjgl9X523ABWvFHVEMt9hS
        ZQ4D0NovQpgbIB+G86MDgeZchg==
X-Google-Smtp-Source: ABdhPJySwEgIk1wlhe/sam1JP4nwt9CL9Bwb+k3i5jgoFi/eE7Ln59o7n1GLDtwUtC3KQ8XRdfaZzw==
X-Received: by 2002:a37:9e48:: with SMTP id h69mr15470028qke.249.1595420279202;
        Wed, 22 Jul 2020 05:17:59 -0700 (PDT)
Received: from [192.168.2.17] (kntaon1617w-grc-04-64-229-0-222.dsl.bell.ca. [64.229.0.222])
        by smtp.googlemail.com with ESMTPSA id r6sm24372519qtt.81.2020.07.22.05.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 05:17:58 -0700 (PDT)
To:     people <people@netdevconf.info>, attendees-0x14@netdevconf.info
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lartc@vger.kernel.org, netfilter-devel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        prog-committee-0x14@netdevconf.info, lwn@lwn.net
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Netdev conf 0x14 update and logistics
Message-ID: <0a3269f5-049b-a042-a368-26a274433006@mojatatu.com>
Date:   Wed, 22 Jul 2020 08:17:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some logistics for Netdev 0x14 virtual conference:

Netdev 0x14 virtual conference will kick off on July 28th
3PM GMT(This coming Tuesday!) with a keynote from
networking industry visionary Nick McKeown.

What does Nick want to talk to us about?
Nick has a vision on how we can work together to realize
a world where owners of large networks can express the
intended behavior they want in their network using a
high-level language, and then seamlessly compile and
deploy it across all their various network devices.

Please come listen, hear him and engage him.

More info:
https://netdevconf.info/0x14/session.html?keynote-mckeown

For more of the good stuff, see:
https://netdevconf.info/0x14/accepted-sessions.html

All sessions will run starting 3PM GMT to allow for the
different time zones' participation and spread across
several days to reduce classical virtual conference
fatigue.

The schedule is at:
https://netdevconf.info/0x14/schedule.html

Note: you can visualize the schedule in multiple different
formats by clicking on the "schedule" pull down menu.
You can also grab a calendar sync on the right hand side
bar.

Dont miss the fun. Registration is open.
https://netdevconf.info/0x14/registration.html

cheers,
jamal
