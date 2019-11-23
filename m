Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4FE107BEB
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKWAOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:14:35 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:46820 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfKWAOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:14:35 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 0F1C213C359;
        Fri, 22 Nov 2019 16:14:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0F1C213C359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574468075;
        bh=j/gHlhhYQwX1CQqisRpHDjh/jM27kPPqfkwKIRotJDU=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=n6n41cTZIygvnKbINr+CVBX6Vp80pvAel4Vv9649pcf+qGaLVoejIUuUlqZKYUrLG
         u2SVMIvhqduU8n8tHA8cmEk31g8KsKJv5c+K10DKZr8Z7i26HwE5vGYxuVHVMkXgL+
         1SAg8IaqKYUnxPyJRUCQoej5w5rdY5A2r+sLVCrI=
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
Date:   Fri, 22 Nov 2019 16:14:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 4:06 PM, David Ahern wrote:
> On 11/22/19 5:03 PM, Ben Greear wrote:
>> Hello,
>>
>> We see a problem on a particular system when trying to run 'ip vrf exec
>> _vrf1 ping 1.1.1.1'.
>> This system reproduces the problem all the time, but other systems with
>> exact same (as far as
>> we can tell) software may fail occasionally, but then it will work again.
>>
>> Here is an strace output.  I changed to the
>> "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1"
>>
>> directory as root user, and could view the files in that directory, so
>> I'm not sure why the strace shows error 5.
>>
>> Any idea what could be the problem and/or how to fix it or debug further?
>>
>>
>> This command was run as root user.
> 
> check 'ulimit -l'. BPF is used to set the VRF and it requires locked memory.

It is set to '64'.  What is a good value to use?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

