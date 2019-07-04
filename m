Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C33A5F4C0
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGDIpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:45:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53327 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfGDIpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 04:45:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so4871021wmj.3
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 01:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5X2/EIqHVF+0PEgAYfjC329Hb9K8g9a0oFQzNItKqKs=;
        b=cHlScxn9I09lFjoRAx/10wWowfZEF9RQRauFN8qffuv65CpuX9WVMtMVNoMuKo8Yik
         3BgFwOZiUQhkzuOI9imDtRkxy6lKLbUG8lAkWKrCqH1BAXS4mABZPoL03YpxzOWQoA0+
         C4cvNgtErHvf26kwvbsHnbh2FXwB0WiPiYUG8Qk2urpUMIP8ZJULNctDAoFaqpbJWyZK
         XOIrVAS1Y5ma4VslySDKoGBYyGuzbIBLXerm24tPIef2+gOIFU+6wiig5HUd7yznqaqX
         N+RHx+4a/Pn5cckgMtwuX9kXv9vW5gQFJl+xiOi05bRSC9xxL/oS9lFRfUmjbYLLT1UF
         +o/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5X2/EIqHVF+0PEgAYfjC329Hb9K8g9a0oFQzNItKqKs=;
        b=ARwJuAXP0kESm0BmE/6hKKVUCUOcsNCnfn8UhF1YyN5rmj8TtyxpuP0SZ8oPIxdclK
         ubS8B4+8n7NgIlRInQTQDHNXchHetNLMlqe3OelL/cgyHeTvl5wI6kaz8Xoqf8H9clqj
         /9vA0LDebYhBz33ZcV2/p9RMlyUoCIeN+l413CGQ7h7XBGUTtDeUYNKXstjyd9ezB9UA
         K8pAKraL13nSYHjW5dKmSiTmbiAkpgNxHP5Obg4AHHRJQmSdy+x5zUyKiXMYgywm1AJZ
         t5xjfZYjMmub7fwMfutcNbvx8CgYSD3cDrxbfdgFy1dgR7MXP8PMXeguJGx2NwrF5A9R
         hP7Q==
X-Gm-Message-State: APjAAAU/e42RBTZ2NQOl5lsp+BDNYojL0CvzA9ff3MSUP7GjcrQEozFq
        pKwhMt5fq1xr/dGzTqcAAKjtXw==
X-Google-Smtp-Source: APXvYqxouxfcOkVdfjlCFfOuUsXX1rEYhNf0xFbLLPyVqMiekPTRB71RQ87P0/PFyi1g/uP0cBz+MQ==
X-Received: by 2002:a7b:cb94:: with SMTP id m20mr11062116wmi.144.1562229932470;
        Thu, 04 Jul 2019 01:45:32 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id a2sm6032047wmj.9.2019.07.04.01.45.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 01:45:32 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:45:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 09/15] ethtool: generic handlers for GET
 requests
Message-ID: <20190704084531.GJ2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
 <20190703142510.GA2250@nanopsycho>
 <20190703175339.GO20101@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703175339.GO20101@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 07:53:39PM CEST, mkubecek@suse.cz wrote:
>On Wed, Jul 03, 2019 at 04:25:10PM +0200, Jiri Pirko wrote:
>> Tue, Jul 02, 2019 at 01:50:24PM CEST, mkubecek@suse.cz wrote:
>> 
>> [...]	
>> 	
>> >+/* generic ->doit() handler for GET type requests */
>> >+static int ethnl_get_doit(struct sk_buff *skb, struct genl_info *info)
>> 
>> It is very unfortunate for review to introduce function in a patch and
>> don't use it. In general, this approach is frowned upon. You should use
>> whatever you introduce in the same patch. I understand it is sometimes
>> hard.
>
>It's not as if I introduced something and didn't show how to use it.
>First use is in the very next patch so if you insist on reading each
>patch separately without context, just combine 09/15 and 10/15 together;
>the overlap is minimal (10/15 adds an entry into get_requests[]
>introduced in 09/15).
>
>I could have done that myself but the resulting patch would add over
>1000 lines (also something frown upon in general) and if someone asked
>if it could be split, the only honest answer I could give would be:
>"Of course it should be split, it consists of two completely logically
>separated parts (which are also 99% separated in code)."
>
>> IIUC, you have one ethnl_get_doit for all possible commands, and you
>
>Not all of them, only GET requests (and related notifications) and out
>of them, only those which fit the common pattern. There will be e.g. Rx
>rules and stats (maybe others) where dump request won't be iterating
>through devices so that they will need at least their own dumpit
>handler.
>
>> have this ops to do cmd-specific tasks. That is quite unusual. Plus if
>> you consider the complicated datastructures connected with this, 
>> I'm lost from the beginning :( Any particular reason form this indirection?
>> I don't think any other generic netlink code does that (correct me if
>> I'm wrong). The nice thing about generic netlink is the fact that
>> you have separate handlers per cmd.
>> 
>> I don't think you need these ops and indirections. For the common parts,
>> just have a set of common helpers, as the other generic netlink users
>> are doing. The code would be much easier to read and follow then.
>
>As I said last time, what you suggest is going back to what I already
>had in the early versions; so I have pretty good idea what the result
>would look like.
>
>I could go that way, having a separate main handler for each request
>type and call common helpers from it. But as there would always be
>a doit() handler, a dumpit() handler and mostly also a notification
>handler, I would have to factor out the functions which are now
>callbacks in struct get_request_ops anyway. To avoid too many
>parameters, I would end up with structures very similar to what I have
>now.  (Not really "I would", the structures were already there, the only
>difference was that the "request" and "data" parts were two structures
>rather than one.)
>
>So at the moment, I would have 5 functions looking almost the same as
>ethnl_get_doit(), 5 functions looking almost as ethnl_get_dumpit() and
>2 functions looking like ethnl_std_notify(), with the prospect of more
>to be added. Any change in the logic would need to be repeated for all
>of them. Moreover, you also proposed (or rather requested) to drop the
>infomask concept and split the message types into multiple separate
>ones. With that change, the number of almost copies would be 21 doit(),
>21 dumpit() and 13 notification handlers (for now, that is).

I understand. It's a tradeoff. The code as you introduce is hard for
me to follow, so I thought that the other way would help readability.

Also it seems to be that you replicate a lot of generic netlink API
(per-cmd-doit/dumpit ops and privileged/GENL_ADMIN_PERM) in your code.
Seems more natural to use the API as others are doing.


>
>I'm also not happy about the way typical GET and SET request processing
>looks now. But I would much rather go in the opposite direction: define
>relationship between message attributes and data structure members so
>that most of the size estimate, data prepare, message fill and data
>update functions which are all repeating the same pattern could be
>replaced by universal functions doing these actions according to the
>description. The direction you suggest is the direction I came from.
>
>Seriously, I don't know what to think. Anywhere I look, return code is
>checked with "if (ret < 0)" (sure, some use "if (ret)" but it's
>certainly not prevalent or universally preferred, more like 1:1), now
>you tell me it's wrong. Networking stack is full of simple helpers and
>wrappers, yet you keep telling me simple wrappers are wrong. Networking
>stack is full of abstractions and ops, you tell me it's wrong. It's
>really confusing...

It is all just a matter of readability I believe.
For example when I see "if (ret < 0) goto err" I assume that there
might be positive non-error value returned. There are many places where
the code is not in optimal shape. But for new code, I believe we have to
be careful.

Simple helpers are fine as far as they don't cover simple things going
under the hood. Typical example is "myown_lock() myown_unlock()" which
just call mutex_lock/unlock. Another nice example is macro putting
netlink attributes having goto nla_failure inside - this was removed
couple years ago. The code still have many things like this. Again, for
new code, I believe we have to be careful.

