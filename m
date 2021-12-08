Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067E846D0F3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhLHK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 05:29:47 -0500
Received: from foss.arm.com ([217.140.110.172]:56272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhLHK3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 05:29:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 292521042;
        Wed,  8 Dec 2021 02:26:15 -0800 (PST)
Received: from [10.57.82.128] (unknown [10.57.82.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D8CA3F5A1;
        Wed,  8 Dec 2021 02:26:12 -0800 (PST)
Message-ID: <5f5648e5-d425-8b6f-a6c2-2fc1252f0c79@arm.com>
Date:   Wed, 8 Dec 2021 10:26:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2 2/7] coresight: etm3x: Use task_is_in_init_pid_ns()
To:     Leo Yan <leo.yan@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-3-leo.yan@linaro.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20211208083320.472503-3-leo.yan@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2021 08:33, Leo Yan wrote:
> This patch replaces open code with task_is_in_init_pid_ns() to check if
> a task is in root PID namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
