Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC2898B2
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfHLIbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:31:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfHLIbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:31:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so10983040wmj.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 01:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IVJYOcOxvAZbODzmljwdfgpd44ra3d2U489gnozslm0=;
        b=A6TWU0LANuh+I+uQ4qnZaHH26Cfid9objZMoSTxnHEgrsvm1yV8ssSOrNLzxHp1xJu
         6oLkd103JUIg/zSwMJvOX/tj+RXAsuEgwj1Sy/ZHcTdrYg1H6q8f2DskejTBQ0exc+YC
         GGJT5fRS4nl8SHEGcUuhPmBVFAx/TokC4R8zbYD7xqwbalDWxFWTZT9YOQWPN7oaU75d
         t+9seHncIym0yNaQxS2v6PGRvbC774sBCbLmgrcrXWxB56o7xv48Vrfd/0SqZd2rgawC
         myyvuDbibp+1yWud7UkbBYpngJ50TTmY7ZhTmnZrBOagAjq19d9MwRng6kE/kiszxLpO
         98IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IVJYOcOxvAZbODzmljwdfgpd44ra3d2U489gnozslm0=;
        b=Kxv+aNGwyN23/1CDO+FXw5XDdRZbaKE7XbeoFjxexQhLtYznucgkry8KOJ41Dd4CyD
         VEVBG9HEniaNuFkQftePHf+V9lruveMdlu/TNsPyca6Z9OfHuqrxcdVT+lAuXZd/usun
         I5isdgXRQPdi8n5IY56hq9od/6Wz5ZySrB2F7/Woi1hFOHRY32998p1bJIP0/YdDQPmz
         8+NWLLMaMIcKLCuxNTMioV35JQlSX9mNOrrnnorSlVwP3AJtkW4j8fiiwxSHaOVaOhfp
         CFxW6dGTGmbPQm4iF8KieKqCMc8h/vPwAAkVBgwfatS9Fm4WjD4yJe8awzB/Le0O5od3
         cjQA==
X-Gm-Message-State: APjAAAWoG3NbdNiKwNhRJ3oZerD/KDfrUcx2wXlQRgtQoxLk0Z3sfBIs
        WzO1QAOIpAuC7uc3T18wTuCd1A==
X-Google-Smtp-Source: APXvYqzsk3cEU93C++C06DOwyGBIgcQN4TGf9qLAfsbvb7b9R8gHtNcIGuw+0pZHONEveNFKlfmKLw==
X-Received: by 2002:a1c:5453:: with SMTP id p19mr11262408wmi.120.1565598701181;
        Mon, 12 Aug 2019 01:31:41 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id p9sm4743697wru.61.2019.08.12.01.31.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 01:31:40 -0700 (PDT)
Date:   Mon, 12 Aug 2019 10:31:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190812083139.GA2428@nanopsycho>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
>On 8/11/19 7:34 PM, David Ahern wrote:
>> On 8/10/19 12:30 AM, Jiri Pirko wrote:
>>> Could you please write me an example message of add/remove?
>> 
>> altnames are for existing netdevs, yes? existing netdevs have an id and
>> a name - 2 existing references for identifying the existing netdev for
>> which an altname will be added. Even using the altname as the main
>> 'handle' for a setlink change, I see no reason why the GETLINK api can
>> not take an the IFLA_ALT_IFNAME and return the full details of the
>> device if the altname is unique.
>> 
>> So, what do the new RTM commands give you that you can not do with
>> RTM_*LINK?
>> 
>
>
>To put this another way, the ALT_NAME is an attribute of an object - a
>LINK. It is *not* a separate object which requires its own set of
>commands for manipulating.

Okay, again, could you provide example of a message to add/remove
altname using existing setlink message? Thanks!
