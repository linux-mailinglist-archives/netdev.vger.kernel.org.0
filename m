Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A405822D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0MIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:08:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40866 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0MIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:08:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so2264273wre.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 05:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C6fTk+TQFhCug33HGJlYxFBKgxrSr+bh/Cs/qWR3Rro=;
        b=CCognjlWK36SWJgmqZjfJ3kNYEc2REwS0O7tHGwAXtia9huGA+tKJSCsPkSWOqpa9X
         nRbLTfalhimdAK5MmwDJexvOG0HSvPHv9xvj8YcTBU7UxrREXh2+eBpCoCR3x/LxkZyv
         Kd2YXYvWxSQIaSiwsG7920Xt9F11MEqGG7Oikb5icQ2p35EHP+wCNVsKM1XZ+H5VRVwX
         e97OorOJXIqiS0AJE4OfoW8zLpHisGZrosQMswJ3zQvvmGTL6wYzSYILT4nBw2Qce9jr
         SoRgWiI2H6PGgHXVKJYZxRrBVYuaAGJBykTHfGiybkOWQwGzlkbA0ORUkU/3aMqxB/LJ
         pjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=C6fTk+TQFhCug33HGJlYxFBKgxrSr+bh/Cs/qWR3Rro=;
        b=CHUiWOrJa8yLmpWXCMsKNlh8MIIYTKyAa1iSAdK5ujXOSjhXPRQQV+fR3lv1jAzztH
         l9tT8Y5DlbXW50O5Gih1d2vqWE7AfgSJtYpUFLgVMPYta2eQZMXuCptmgalM45PM2Q4x
         zQx+ijDfxPan1WvOOjJTZRSnsQvQCwXiLQqy/8Ng1KhHLOSLgvQi7+TTnNERBH1UipZE
         jfB3/2uO7xYzxe1DAes8Y1TbM7UsnwWFTXWlOuPoNaA1N0ixFiPvXmGOBux+3hNacjZe
         NDa2bNCJRKbw4adqZDC2Tsj7DLbHVvXenn78wkhP026DID82yg4kZf9kzfi7DniA0k9d
         +rfw==
X-Gm-Message-State: APjAAAWVJhIgXPX+7NiZZCMy+LEN/oDBVrSHItTkwCfAWEGLmgG2lXvn
        YfVwMIQbOCtjH/tJFCC/I7ChhQ==
X-Google-Smtp-Source: APXvYqypa5j4JGnLG4I89usLRuJ8in+Zttfpp8az8zMHutdktu6D/6FIKa0PNfPZS0qFRexmUG5xeg==
X-Received: by 2002:a5d:4b12:: with SMTP id v18mr3153812wrq.123.1561637289951;
        Thu, 27 Jun 2019 05:08:09 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:a958:42c8:83cd:e1a5? ([2a01:e35:8b63:dc30:a958:42c8:83cd:e1a5])
        by smtp.gmail.com with ESMTPSA id h6sm2785143wre.82.2019.06.27.05.08.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 05:08:09 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC iproute2 1/1] ip: netns: add mounted state file for each
 netns
To:     Alexander Aring <aring@mojatatu.com>, netdev@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, kernel@mojatatu.com,
        David Howells <dhowells@redhat.com>
References: <20190626190343.22031-1-aring@mojatatu.com>
 <20190626190343.22031-2-aring@mojatatu.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <293c9bd3-f530-d75e-c353-ddeabac27cf6@6wind.com>
Date:   Thu, 27 Jun 2019 14:08:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626190343.22031-2-aring@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/06/2019 à 21:03, Alexander Aring a écrit :
> This patch adds a state file for each generated namespace to ensure the
> namespace is mounted. There exists no way to tell another programm that
> the namespace is mounted when iproute is creating one. An example
> application would be an inotify watcher to use the generated namespace
> when it's discovers one. In this case we cannot use the generated
> namespace file in /var/run/netns in the time when it's not mounted yet.
> A primitiv approach is to generate another file after the mount
> systemcall was done. In my case inotify waits until the mount statefile
> is generated to be sure that iproute2 did a mount bind.
We (at 6WIND) already hit this problem. The solution was: if setns() fails, wait
a bit and retry the setns() and continue this loop with a predefined timeout.
netns may be created by other app than iproute2, it would be nice to find a
generic solution.

David Howells was working on a mount notification mechanism:
https://lwn.net/Articles/760714/
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=notifications

I don't know what is the status of this series.


Regards,
Nicolas
