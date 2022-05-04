Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5EF51B15A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354511AbiEDVwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDVwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:52:49 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911F250B06;
        Wed,  4 May 2022 14:49:12 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id EFC23C020; Wed,  4 May 2022 23:49:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1651700950; bh=u5EzJCGt1bErRRL17AVGrTn+Rx5euZvZx9/3VtmBl/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xevsfCukgGD/UgrKS0F+HuWDBgHAZPMM1JT5Kqd5ZZfBU81TjAnFttFP42nQ8rIcu
         ol1P3n6y/ktfAUwolxNj45SZUnCgqhRhkwYWoSCogsMFmDRr4LtRRLliiIAySldQKM
         IoHrD9132/7D4p634KQRd96dpSwbM3xAHNHfEVbuM603wJxoNDpbj61jrUCIrvE/4d
         Z+QpML04BV4I2PajkVAcXiUWw8VpODtO9ct9V+piwY0G9wavuYLCoTFQ7NpQyFMfEr
         J5gs1KkTtSZU3vuJWS+wlX6dV6hWbCJ6uOOiiRFTFwLEuSHHfPRGcmj5cnEyOV+Ml5
         cOhzSHaZ+MEcw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 1B718C009;
        Wed,  4 May 2022 23:49:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1651700950; bh=u5EzJCGt1bErRRL17AVGrTn+Rx5euZvZx9/3VtmBl/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xevsfCukgGD/UgrKS0F+HuWDBgHAZPMM1JT5Kqd5ZZfBU81TjAnFttFP42nQ8rIcu
         ol1P3n6y/ktfAUwolxNj45SZUnCgqhRhkwYWoSCogsMFmDRr4LtRRLliiIAySldQKM
         IoHrD9132/7D4p634KQRd96dpSwbM3xAHNHfEVbuM603wJxoNDpbj61jrUCIrvE/4d
         Z+QpML04BV4I2PajkVAcXiUWw8VpODtO9ct9V+piwY0G9wavuYLCoTFQ7NpQyFMfEr
         J5gs1KkTtSZU3vuJWS+wlX6dV6hWbCJ6uOOiiRFTFwLEuSHHfPRGcmj5cnEyOV+Ml5
         cOhzSHaZ+MEcw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3bcfa5ec;
        Wed, 4 May 2022 21:49:02 +0000 (UTC)
Date:   Thu, 5 May 2022 06:48:47 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Howells <dhowells@redhat.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark
 (was: 9p fscache Duplicate cookie detected))
Message-ID: <YnL0vzcdJjgyq8rQ@codewreck.org>
References: <YmKp68xvZEjBFell@codewreck.org>
 <1817722.O6u07f4CCs@silver>
 <YnECI2+EAzgQExOn@codewreck.org>
 <6688504.ZJKUV3z3ry@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6688504.ZJKUV3z3ry@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, May 04, 2022 at 08:33:36PM +0200:
> On Dienstag, 3. Mai 2022 12:21:23 CEST asmadeus@codewreck.org wrote:
> >  - add some complex code to track the exact byte range that got updated
> > in some conditions e.g. WRONLY or read fails?
> > That'd still be useful depending on how the backend tracks file mode,
> > qemu as user with security_model=mapped-file keeps files 600 but with
> > passthrough or none qemu wouldn't be able to read the file regardless of
> > what we do on client...
> > Christian, if you still have an old kernel around did that use to work?
> 
> Sorry, what was the question, i.e. what should I test / look for precisely? :)

I was curious if older kernel does not issue read at all, or issues read
on writeback fid correctly opened as root/RDRW

You can try either the append.c I pasted a few mails back or the dd
commands, as regular user.

$ dd if=/dev/zero of=test bs=1M count=1
$ chmod 400 test
# drop cache or remount
$ dd if=/dev/urandom of=test bs=102 seek=2 count=1 conv=notrunc
dd: error writing 'test': Bad file descriptor

... But honestly I should just find the time to do it myself, this has
been dragging on for too long...
-- 
Dominique
