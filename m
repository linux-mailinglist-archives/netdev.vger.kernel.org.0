Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6D547A1B8
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 19:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhLSSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 13:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhLSSSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 13:18:07 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F2EC06173E
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 10:18:06 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id t6so7465643qkg.1
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 10:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=YnzxR+zGPCGbgabAVJEGSsPKA91JSV6H5wy0yrO7uQw=;
        b=EuPiXgh5qFbJI3PIBRuEYpPvol7LpgeV0mGVnDS9Mq4dtWZ54GGnw9iZs6pSbnGlsa
         LuHSQG+qRs2sYBq+gXaOydzjrDPrSnYWou19ITglS2LnzGXOLOg94cmXn+UEBb41PMon
         aq7sznPHA9XhZlnNj1aOY2mQsqaSadEfrv9rC05jFwiX1Mx+2E1uRRND4dQC1geIIRNd
         QOacefBKztnuTiA+Eh35Md4nOvi5G5/globUzPadIWBmki984NOr+i61u1fN3xUfEXpn
         R16+e8w2RDInuUdKDJsfMlDFMjrYzjzAS0sXoOtbCMvKzWSRCBphH9xH0e2om1nPeYZH
         0b9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=YnzxR+zGPCGbgabAVJEGSsPKA91JSV6H5wy0yrO7uQw=;
        b=Mbc/+pnYE5OVXbvC99Hng/wCLAQaAvfA5+4qzasQdphugxKvB+tvNymZyVHDX5R/1t
         +xMtYxum6uUmIUwAjguSDiqwWqaO7HCP2UHBNd3bjwkI80jeFmSleRBFhxWR8viVUaPJ
         AXzdYvfS14WUN4W/2yYDXaST9cAEPM6Y/74DfESq5uxlT0MnxwMQnrqd2g+zZUCbW2k1
         JnC+1/dERJOhHQvS4N54DaNT2gjXHMCBeqv3rrcNK7bwIt3WId/0jafF2Ee7q1p+KS+U
         D/3zdT4XJfkiF4Uh+FTQH4stkdkgSa2clbOLxnN/j9Nohuptazij8xjV1zQA03H5y/PP
         ueUw==
X-Gm-Message-State: AOAM5332DvzP6Ehvl//AhUPmYLg9NxkSwRrQaNrzjg0qggudbiXqpbXh
        S2upcNBivQbtRIZwfive7pgzV6/DT3sXTA==
X-Google-Smtp-Source: ABdhPJzG8nLF8kGdqcdslzXwk/T0kcrG3ai4uQ98nXCN0HrfFnsYOy70g3uQk86h5Bmq0vdZqn1nJQ==
X-Received: by 2002:a05:620a:13ea:: with SMTP id h10mr3700212qkl.30.1639937885897;
        Sun, 19 Dec 2021 10:18:05 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id f34sm13926768qtb.7.2021.12.19.10.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 10:18:05 -0800 (PST)
Message-ID: <93260ae6-9933-7806-10cb-ee345fa5925d@mojatatu.com>
Date:   Sun, 19 Dec 2021 13:18:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     people@netdevconf.info, netfilter-devel@vger.kernel.org,
        lartc@vger.kernel.org, linux-wireless@vger.kernel.org, lwn@lwn.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "board@netdevconf.org" <board@netdevconf.info>,
        prog-committee-0x15@netdevconf.info,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: netdevconf 0x16
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is an announcement in regards to netdevconf 0x16.

At this point we are looking at the following parameters:

Date range : Oct 15th to Nov 8th, 2022

Location : If we are lucky then some form of physical meeting
will take place. The choice we are contemplating is Southern Europe
with Portugal preferred as a venue.

The cloud around the pandemic is a factor in our decisions and
a silver lining is that, going forward, we are making the
virtual aspect of the conference permanent.
In addition, we are also continuously thinking about the conference
structure and trying to adapt to the new life variables presented
to us. You can help influence the decisions by taking part in
a poll that will be conducted on people@netdevconf.info mailing
list.

sincerely,

Netdev Society Board:
Roopa Prabhu,
Shrijeet Mukherjee,
Tom Herbert,
Jamal Hadi Salim
