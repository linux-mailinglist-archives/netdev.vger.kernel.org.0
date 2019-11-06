Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED4DF1EBC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKFT1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:27:34 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46889 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfKFT1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:27:34 -0500
Received: by mail-il1-f196.google.com with SMTP id m16so22775708iln.13
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 11:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jEm87NDRGVL4luEEVhaurkDvk8/jnyPiMjSYhCHgskg=;
        b=bIjXhVSNLmKIvcEBCd/otS0hzmp9pEyM7o2hc4N7eW1a5Gyrgha/ncTqSXVXhaPiVH
         fZ5ORH/plmvHB0SK0squKFReefz30WymnLlAPbimVtNaHDphp2rzjWN05X5Tp1DBWEz1
         P/QkivEVRoN/uxq7EUywk0UneB9nCIa6ZIY2CGrGFwqC+/7PSm6Q9Jy8HyOxcMn5+/xU
         5H4K0Om5VQBJ/mNbZxbNyxtey00qk/Pdt9fN+VEhzzNg5ANdE6dNR2ubCNX5QS7GJomU
         9oOT2wIVfhkZdd22jTc4tu6FmS0ay3dbMg9TFM2/ctKb+FzDn5+Wtr0jqlFLNmeLRNf/
         acaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jEm87NDRGVL4luEEVhaurkDvk8/jnyPiMjSYhCHgskg=;
        b=q1lSCl1z7tHgUfftbQqDgmCtHVv8v1InHGENVSFJD44+HetgKIT9WghEaF46FJjn3M
         MFrPmL0koUv+t6u0zSbXShS5KwPYQ6SW7Oag0vd6Tb1re2gbfdK9TbH+rLMD4JjMuxyS
         CvRVd8OO85SVfyUgpSefqQumkmZhIXJUwdXzPDgrH14k278ba1kkhV862W7qcvJaMyM2
         dtaG9qA9ZFELvjR8aA6HsqqelBqog9QPgTa/RwOomz9hs89Qlmv/FUBKThvVjO749Loh
         zEnDgFl6mmKzjM1mehx0osgzu2V9pjRnslQ4O6QBLz4M3Q8+L5KtCE1QkhO+IsFoLztJ
         segw==
X-Gm-Message-State: APjAAAVcTQSDh3XJFfR101ORz1fWlul7ruYwZXJSouHNwUG43sH9wAyo
        9mIH26GlU19a4p1cKTibNVl4LiRG
X-Google-Smtp-Source: APXvYqxl69no5Xay+gVqBoupQe1ptkiqbgcLwgbjkCcKKqEmw6/a8tyD3QJmMycyrVv5OOi104vypw==
X-Received: by 2002:a92:46c7:: with SMTP id d68mr4927659ilk.133.1573068453184;
        Wed, 06 Nov 2019 11:27:33 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:ec38:6775:b8e6:ab09])
        by smtp.googlemail.com with ESMTPSA id e13sm1418637iom.50.2019.11.06.11.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 11:27:32 -0800 (PST)
Subject: Re: SIOCSIFDSTADDR for IPv6 removed ?
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <63900c63bcb04f226fba538fd31c609c8ff6e776.camel@infinera.com>
 <038e090c-b9cb-a15d-6aea-4a5ccbc6e95c@gmail.com>
 <df2cf840fcf7f8c920c102bf7433d362bb9044cb.camel@infinera.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <468a299b-7f9c-fd3b-bf03-a77f9ff4f77a@gmail.com>
Date:   Wed, 6 Nov 2019 12:27:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <df2cf840fcf7f8c920c102bf7433d362bb9044cb.camel@infinera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/19 12:16 PM, Joakim Tjernlund wrote:
> On Wed, 2019-11-06 at 08:55 -0700, David Ahern wrote:
>>
>> On 11/6/19 4:34 AM, Joakim Tjernlund wrote:
>>> From what I can tell, it is not possible to set DSTADDR in IPv6 and I wonder why?
>>>
>>> There is an expectation for IPV6_SIT which can but am using pppoe and there I cannot.
>>>
>>
>> Code is still present and does not appear to have been changed recently.
> 
> Right, IPV6 seems to have been like this(no support for DSTADDR) forever, but why?
> Is it because none has impl. DSTADDR for IPv6 or is there a reason?
> Would a patch adding IPv6 DSTADDR be accepted?
> 

If you have a legitimate use case that is not working, send a patch. Add
a test case (or more) to tools/testing/selftests/net/fcnal-test.sh,
use_cases().
