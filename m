Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E9D8FED5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfHPJXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:23:42 -0400
Received: from pigeon.groveronline.com ([198.145.19.6]:34440 "EHLO
        pigeon.buunabet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726864AbfHPJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:23:41 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2019 05:23:41 EDT
Received: by pigeon.buunabet.com (Postfix, from userid 501)
        id 4569160818; Fri, 16 Aug 2019 02:15:28 -0700 (PDT)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on pigeon.buunabet.com
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.5 tests=ALL_TRUSTED
        autolearn=unavailable version=3.3.1
Received: from [10.241.119.227] (unknown [217.116.215.226])
        (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        by pigeon.buunabet.com (Postfix) with ESMTPSA id 91A1860662;
        Fri, 16 Aug 2019 02:15:25 -0700 (PDT)
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
To:     Gerd Rausch <gerd.rausch@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Chris Mason <clm@fb.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        Chris Mason <chris.mason@oracle.com>
References: <20190816075312.64959223@canb.auug.org.au>
 <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
From:   Andy Grover <andy@groveronline.com>
Openpgp: preference=signencrypt
Autocrypt: addr=andy@groveronline.com; keydata=
 mQENBFz6mPMBCAClDMGqYBeCSE0Q+rU7v0JibtGh+nSZoNTSdXOHUkk3rN7rmJwdjlWsL0aT
 2BGsSYBQjuqlculeJAQq6GG8dj7gjkDX8zVvjNPVqZxNd0bRh9DFE5AZrz3TiTIUwNauKWE9
 XvVCMn/ZfzEJhehLa7SUs5vgZ6NHaScq4KZByfNsmiu/n+mPRhJOjgIN7fql5u+ElnNHxOP3
 Z9vsoQc5pS9YAMKtEvyWgljm4fbZMs6VBDUGJGaLRmALF5VrJ5AJKzbZWZmaXYNqoxdtakT5
 PhJuXkqdnrijZw8TJCglQ/z2wiq2HCU2pzq6/l+19yV0m9iegEuPgtAuwqkh4ecsPAbbABEB
 AAG0IUFuZHkgR3JvdmVyIDxhZ3JvdmVyQG1vemlsbGEuY29tPokBVAQTAQgAPhYhBKVh7hV4
 1gY7lZbAkBVqKb2tr6NBBQJc+pjzAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheA
 AAoJEBVqKb2tr6NB7uwH/RIEtXUCpRGCbVO5LyXmlzTCue9djrb8YrvOOyeVzUxA5kIskguB
 5DH7X7RuVa1PlsfsG2F40/5/bPS/fjYIUOGxTQdyiXGeVPotDvg4vaC/3zV16gs8YxOgzKgb
 P7QhFLHkZoITe6gOv4R0QH1qvRkbg9cyyPr5FoIPaLoXDnw4DWxaNBUSsN+fPRI87yUjPO1v
 kL+OWBOnBsHxNGaHjd/s9WsIUp8RbLbfMEI+xlM8lM+r5ccECkMS/l9NFX+mCMUlRXqTkd49
 mWYJWY5zNnLyqbAZcaRGCrFlX/gjDn8p+pXQEdvtbbqy3KMofxrmf73ECSStM0WnOEgWtSFG
 ycW5AQ0EXPqY8wEIAMY7xc/W7mIt2nyAe9K/5RiuyGaDItuaEbFzfRmxFvISJm3s5LiyyrGA
 82o0HQWqoMjPyLd+pGSSxHL5aWCUsj5vt/rV0FCPvC8W3a0bWxHa+sbb0VeAHna18Ozav1Cx
 RFLW437tqaD8yF5yh1c0aGolCqv2LjMHetm+UmFoQVbSfcJoxpXepJFVDwvrqqlL+5BoQM15
 MzCwux/D8RCgNlTXTnlfm6bRvlD5ttgDoyzN7qYwm+RjA9Izhyps39fKzdk8xkgeu/A55C94
 KcPuSs4U9ti7WeU+CubDaLB3bxp7KCyjWpX3oS2CxHFnQsBAbzGx8UeH3dXbdni1AjE71wkA
 EQEAAYkBPAQYAQgAJhYhBKVh7hV41gY7lZbAkBVqKb2tr6NBBQJc+pjzAhsMBQkDwmcAAAoJ
 EBVqKb2tr6NBP2MH/0g/e3idsu/ajGzRx6CaRd/ZNxG0/p0aYT4iQWUEt0KZVyHKf17OQK2z
 u3QSGjSR2V1H419U0m5V3HSMQmy5XrGi3ks4f01Cgq2HiYizhwVwqNVfZERY+WavEIr35w/L
 eJqEI2Cm4PySxbOOuFig6R7GAknL76iKQBlMH8uX7yV9p0JnrI6tn0lm2n4UjW76CJ3Fk6gD
 wqoDYDQXfIxYtyMD6QUfiSDZ+8KZoCMDYQQsEcDBz0hRI2mHwL1jHkGNMcVOhBZPtUHinFTc
 EiQKDXQKkBvschbpbcfJI5g82v6Bl5M995ob7wsXy8VN5+usot+bKqQHGYMsBMbqJf+Ci1I=
Message-ID: <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
Date:   Fri, 16 Aug 2019 11:15:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 3:06 PM, Gerd Rausch wrote:
> Hi,
> 
> Just added the e-mail addresses I found using a simple "google search",
> in order to reach out to the original authors of these commits:
> Chris Mason and Andy Grover.
> 
> I'm hoping they still remember their work from 7-8 years ago.

Yes looks like what I was working on. What did you need from me? It's
too late to amend the commitlogs...

-- Andy

> 
> Thanks,
> 
>   Gerd
> 
> On 15/08/2019 14.53, Stephen Rothwell wrote:
>> Hi all,
>>
>> Commits
>>
>>   11740ef44829 ("rds: check for excessive looping in rds_send_xmit")
>>   65dedd7fe1f2 ("RDS: limit the number of times we loop in rds_send_xmit")
>>
>> are missing a Signed-off-by from their authors.
>>
