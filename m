Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A559605BE7
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJTKN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJTKN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:13:58 -0400
X-Greylist: delayed 839 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 03:13:57 PDT
Received: from level.ms.sapientia.ro (level.ms.sapientia.ro [193.16.218.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F0121D0671
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:13:57 -0700 (PDT)
Received: from localhost (level.ms.sapientia.ro [127.0.0.1])
        by level.ms.sapientia.ro (Postfix) with ESMTP id EC2646CD5847;
        Thu, 20 Oct 2022 12:58:29 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 level.ms.sapientia.ro EC2646CD5847
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ms.sapientia.ro;
        s=default; t=1666259910;
        bh=0E9m7amv2gS5FYAp0O+/uRtUTrfd4d6FtPUURJxepf8=;
        h=Date:From:To:Subject:Reply-To:From;
        b=QWWdwZRFK+9SSI9AJ8Z69aUKPnTicn/jxfFvtQHJAJEzKFYIInzUH7oNG34BV0JZ7
         /3gcFYK2jA6oJtdG8PDE2Oj3xZVWwi9qFQuZ1QcE6MkA9pNJoCEFD+yj9QHKAhsigE
         gwQR/jnrcHjlv4sHnVQ4OVE5URUN+LSOLKIGr9jY=
X-Virus-Scanned: by B3 SapScan
Received: from level.ms.sapientia.ro ([127.0.0.1])
        by localhost (level.ms.sapientia.ro [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PHmZ30kOndtF; Thu, 20 Oct 2022 12:58:28 +0300 (EEST)
Received: from level.ms.sapientia.ro (level.ms.sapientia.ro [127.0.0.1])
        by level.ms.sapientia.ro (Postfix) with ESMTPSA id 4B56C6CD454D;
        Thu, 20 Oct 2022 12:58:24 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 level.ms.sapientia.ro 4B56C6CD454D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ms.sapientia.ro;
        s=default; t=1666259905;
        bh=0E9m7amv2gS5FYAp0O+/uRtUTrfd4d6FtPUURJxepf8=;
        h=Date:From:To:Subject:Reply-To:From;
        b=evyY8oMW/xf5hrlfGz9npQfTTdCOxs0z0qWpYUqxJfTWRM0WVkd6qkSfvlU7Cuhpt
         cx671joQtYPKlj2hgSs8OjujSwcMBBX9fvJXVqRdHxhESnpSmW2MxseyhA55BlKKBw
         Bntul9NDTaeRZxK3+oZdHoxFPKyfkFdFweODYhIo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Oct 2022 11:58:24 +0200
From:   Evan <molnarkati@ms.sapientia.ro>
To:     undisclosed-recipients:;
Subject: Hi Gorgeous,
Reply-To: bakker.evan01@gmail.com
Mail-Reply-To: bakker.evan01@gmail.com
Message-ID: <3741c8fcf5b6afa7f03db6c29ab9ebaa@ms.sapientia.ro>
X-Sender: molnarkati@ms.sapientia.ro
User-Agent: Roundcube Webmail/1.3.4
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,ODD_FREEM_REPTO,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: sapientia.ro]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [bakker.evan01[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 ODD_FREEM_REPTO Has unusual reply-to header
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gorgeous,
Am sorry to bother you, but I am single and lonely in need of a caring, 
loving and romantic companion.
I am a secret admirer and would like to explore the opportunity to learn 
more about each other.
Hopefully it will be the beginning of a long term communication between 
the both of us.
Please let me know what you, will be glad to hear from you again.
Hugs and kisses,
Evan.
