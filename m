Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB235A715
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbhDIT0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:26:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:15048 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhDIT0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:26:21 -0400
IronPort-SDR: cejcgb3A32ZiuYOwrXx9AsVZ26qaf196zte1yuUjEcleIgFkhOoghBbw4Ifqt0C6Hbcv8hvEFy
 gv5oN8xbZ9Ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191678591"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191678591"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:26:08 -0700
IronPort-SDR: khjZaMZqAYHRcrgzO3Z8fi8TjQibQSfqWrCWFJmjkH5N4mZ4l+CkYq5Hlu1eJZ/tqeMm5Vr5xd
 A/uf2uKSmgHw==
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="422857448"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.251.215]) ([10.212.251.215])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:26:07 -0700
Subject: Re: [RFC] net: core: devlink: add port_params_ops for devlink port
 parameters altering
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, idosch@idosch.org,
        Parav Pandit <parav@nvidia.com>
References: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
 <ce46643a-99ad-54e8-b5ed-b85ca35ecbcb@intel.com>
 <20210409170114.GB8110@plvision.eu>
 <20210409113707.4fad51dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <1a55a2ed-318e-176d-812b-2762d93c95a4@intel.com>
Date:   Fri, 9 Apr 2021 12:26:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210409113707.4fad51dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2021 11:37 AM, Jakub Kicinski wrote:
> On Fri, 9 Apr 2021 20:01:14 +0300 Vadym Kochan wrote:
>> On Fri, Apr 09, 2021 at 09:51:13AM -0700, Samudrala, Sridhar wrote:
>>> On 4/9/2021 9:22 AM, Oleksandr Mazur wrote:
>>>> I'd like to discuss a possibility of handling devlink port parameters
>>>> with devlink port pointer supplied.
>>>>
>>>> Current design makes it impossible to distinguish which port's parameter
>>>> should get altered (set) or retrieved (get) whenever there's a single
>>>> parameter registered within a few ports.
>>> I also noticed this issue recently when trying to add port parameters and
>>> I have a patch that handles this in a different way. The ops in devlink_param
>>> struct can be updated to include port_index as an argument
>> We were thinking on this direction but rather decided to have more strict
>> cb signature which reflects that we are working with devlink_port only.
> +1 for passing the actual pointer
OK. This way we don't need to change the existing users of devlink param 
ops.

