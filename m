Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1434F1BAB15
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgD0RXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgD0RXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:23:38 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BC9C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:23:37 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id fb4so8927721qvb.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G0tOC1VP/Zi0lKxSS934DjM1FO16yDxdz7P8FinvAc4=;
        b=pgwwXHTPgch2jNmSEzYYws5DKQ/janAlAFe8rL7I0w9gc3WGX6Gsk3LzAIodUOoGaJ
         HuRDaspOIdIt3CWT8muOs3JtCLI5FaRESvKxT8V49RffhMnj7bapOKdVXhJkmAogjbGT
         Fr56c5DTCwAUfchWslcmu/HVPiqiBSxXyuvXsojDoXizZEvjxc0aqU4jBQzuBl1BBML2
         /Upp7w04MmRgJcbTqGFlb3G/GbSTb3+Gd2H21xR6TrN0sKhH9m1LUkwX8Vl7BynIRRbj
         SUKXVoiPhnrkZQyzKdM8+FKAmCAGAz1Fcjw9YYGwIzt1MA1WYL7Wf7aM1fnyfnnMIwJ0
         OWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G0tOC1VP/Zi0lKxSS934DjM1FO16yDxdz7P8FinvAc4=;
        b=jtMqAu8hGvD5ULjuRCUiD0zuMm4eXLTuDdcZE4RiGPXvvTgrDJEXBbweZhlUWkC5Dx
         3oHa7uFWzhlu+WsWl+gP8GWwAEl54VXiyRTgwLEmFWrLlpERKImB6iuPsxgJzV/0rMlm
         dOJ++rqpeNlZLmJKjHxblLkSVoYBZ5F99S9m2khk2hEJJ7NT3aLzdqpmwFqu+nmVkRRD
         xqBUP8Tg+AtcxXvWhANccSdIbqdcHOzV1vOpztcIWPe/HCF2Bj9mRxu0cgHZuc8UUsRN
         jzKZFG/Gi0zhmxcTOQM4wCMOTXUxYCIjTf3tpH0YU0UonpZmHWCJLO2QuHFRQRye0Cix
         /9tQ==
X-Gm-Message-State: AGi0PubOR0f15vc6MLYAiQQW0RCQoDAyJjIZLJZLOXHmHlJuAUuCvzXd
        N/VHsLwCKg2PYI4/qcXK1xWcBAuy
X-Google-Smtp-Source: APiQypLPG5/XCdhMVIjKPUsxQlnNwQVzEvnY3TAuxrzwqHdpwNIPT6wG17odo66POukO3aos7a8tjQ==
X-Received: by 2002:ad4:5592:: with SMTP id e18mr23698746qvx.13.1588008216743;
        Mon, 27 Apr 2020 10:23:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id j90sm11358000qte.20.2020.04.27.10.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:23:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] selftests: net: add new testcases for
 nexthop API compat mode sysctl
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com>
 <fd7e0fa8-dc1b-b410-a327-f09cbe929c82@gmail.com>
 <CAJieiUhpM7r0Ly4WUqvCJm34LUjuj=Mo5V9JiWrVTd=nLiAMHQ@mail.gmail.com>
 <CAJieiUiRdbPUWe0oKR2T_y+LgWeZfMqzhFMPjaw2KsqmrdeuxQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1c67f0af-cdcb-1844-5466-4853df1fc3e0@gmail.com>
Date:   Mon, 27 Apr 2020 11:23:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAJieiUiRdbPUWe0oKR2T_y+LgWeZfMqzhFMPjaw2KsqmrdeuxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 11:15 AM, Roopa Prabhu wrote:
> David, I still see pref with the latest iproute2-next. I have removed
> it from v3. But there are other tests in fib_nexthops.sh that still
> use 'pref'. Just fyi. I don't plan to respin the selftest patch,
> unless you want me to. Just fyi

it was moved from last nexthop to prefix. The script on net-next ran
cleanly for me with latest iproute2.
