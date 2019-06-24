Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB9351D59
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbfFXVrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:47:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41336 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbfFXVrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:47:40 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so4961253ioc.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lOu4VizyCMbQ2HdCvbtxAojJ0HZkUYZ3D4eZ2+jHII4=;
        b=eHuqrpxSOU3dnjcqsN5Tu9L9RV0Ka4R07a3QCIhzu2LawDSepWrIajsLBL70PKXtHI
         l2J7DXBpPST1PkaN+qhwKPRhqz7lBXfzMnYSnIyhG5aUyO0lcb2IW5RtamMSa8YoRvwj
         4805Y0fL6rShvfTcOknq3tbEg+RD5rgZH9U1Ts2WPNnuYFRjzl6DAreNqDpec+iJPsOf
         x9xiAOYTyrdK37SevD3Tt+Wrk1rtnlZyS9We/tCwm0Y1I4zblsaAQQJtT2noUSrih4sk
         TR6p1QO1iQmUEiPan679LXbxGnjjmqtxFAfpIsnMvgbbSl/vVkas+6Zp1RMFpB6os2rG
         Y2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lOu4VizyCMbQ2HdCvbtxAojJ0HZkUYZ3D4eZ2+jHII4=;
        b=JpyLPT8eaSOvZWKKtMXQNFuxlUqAAFraKwP901AkZLCOur5DuRA5A09iJQB4NVrTx1
         eET2fbkH+dHlt8rcgoCM0HUtCl+uLGIkeDDZe8d0xTd5x4BF44KTJckKaBcWNMFKredt
         lk17TpnWOTUhekKxE8Kezie9VY2pbwJ6STEHjse69iCV1bhG0X6BfnzU26Tw9HNaIxc/
         V/eKDWgSJnNfLpEojIv9b+K3pv49RsCy6j6XOQx9LukVBBtsfQvO/oA3FBg+wzB3m0rn
         UdvADh4vYeRJnQt2NVgUnIKCJte8jzLM+Mth6yQNnxV8n5iXME2LgB47B3JBhLXJbfs0
         nkgw==
X-Gm-Message-State: APjAAAVGmfpXg9spN/+ejKvdgScNyUvXTo7rupWrMmF6cxla90wWQCBa
        B/oNqslD+5B+sgBO7jyelcR40w==
X-Google-Smtp-Source: APXvYqw9yby+dPIQ4yJjkwhbYTXM57vTQRD2jPKm36giUQco1l7iMEELVdSVEEm6ZRmJqKGVllRNzw==
X-Received: by 2002:a02:85ef:: with SMTP id d102mr47301348jai.63.1561412859708;
        Mon, 24 Jun 2019 14:47:39 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id s2sm9659931ioj.8.2019.06.24.14.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Jun 2019 14:47:39 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:47:32 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Scapy plugin and JSON
 verification for tdc
Message-ID: <20190624214732.irc5n56oyk7wfrwe@x220t>
References: <1560133232-17880-1-git-send-email-lucasb@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1560133232-17880-1-git-send-email-lucasb@mojatatu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lucas,

On Sun, Jun 09, 2019 at 10:20:32PM -0400, Lucas Bates wrote:
> This is a draft version of two new tdc features.
> 
> First, the scapy plugin. This requires the scapy Python module
> installed on the system (plugin was tested against v2.4.2).
> The intent is to install a given rule (as the command under test)
> and then generate packets to create statistics for that rule.
> The stats are checked in the verify phase.
> 
> A new "scapy" entry appears in the test cases, which currently
> have three requirements: the source interface for the packets,
> the number of packets to be sent, and a string that is processed
> by scapy's eval() function to construct the packets.

eval() is not a function of scapy, it is a python thing.
You need to be careful with that, people can introduce weird code. Since
everything is here under review I think it is okay... so far we don't
introduce a tdc restful API for that.

> 
> Limitations: For now, only one type of packet can be crafted
> per test case. Also, knowledge of scapy's syntax is required.
> 

Why not add a list of eval() strings and send them out in order?

> Secondly, we add JSON processing as a method of performing the
> verification stage. Each test case can now have a "matchPattern"
> or "matchJSON" field which governs the method tdc will use to
> process the results. The intent is to make it easier to handle
> the verify stage by not requiring complex regular expressions
> 
> matchJSON has two fields, path and value. Path is a list of
> strings and integers which indicate the path through the nested
> JSON data - an asterisk is also acceptable in place of
> a number if the specific index of a list is unknown.
> 

Can you provide an example?

> This structure may not be the best method of handling JSON
> verification - suggestions have been made that include using a
> third party module to process the JSON, but that creates an
> external dependency for tdc.
> 
> To try the sample tests in this patch:
> 
> 1) Ensure nsPlugin and scapyPlugin are linked in the plugins/
>    subdirectory
> 2) Run:
>     sudo ./tdc.py -f tc-tests/actions/scapy-example.json -n
> 
> The second test is designed to fail.
> 
> Comments and discussion are encouraged!

Can you please split these patches according to your commit message.

1. JSON processing (new core feature?)
2. scapy plugin (should not touch core code)
3. scapy example

- Alex
