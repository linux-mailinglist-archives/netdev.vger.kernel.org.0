Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEDA9B6A8
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405074AbfHWTJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:09:35 -0400
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:42966 "EHLO
        resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730788AbfHWTJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:09:34 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2019 15:09:34 EDT
Received: from resomta-ch2-15v.sys.comcast.net ([69.252.207.111])
        by resqmta-ch2-12v.sys.comcast.net with ESMTP
        id 1EAzi1fUAvBbZ1Erhi9g4I; Fri, 23 Aug 2019 19:04:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
        s=20190202a; t=1566587089;
        bh=etZiqvXk5GAsAW4V7yahQT3JIIyVsMviyASPsKZU0Z4=;
        h=Received:Received:From:To:Subject:Date:Message-ID:MIME-Version:
         Content-Type;
        b=EzTNakK9u4ByZuwTrKV3PVgCzCe+cZaUXd31rIdH52xGoCsGYoNA3E33hXUT1hwCB
         y3c2qVjK1Jq7FTSMXE4OjD4ae70Li2d2nZ/Y0AE4D/fq8nC9kt9aLYFB6gqdjApprD
         FVdZCwh2TfdXTah9nSe+DYtCW1DxiXhDMeu+mXgPCkX0ezzP3k2Cb6bu9v/Hn2c1Mp
         WWv8nastB+jCxUC2henfZk2GHbwfKOrsLHLsSs/84m3hCcS+vqQvgtlk0r2gaFpgSa
         LKf39W2BD8O1P2xY/nI7BUefswItV7LcpJQ5LDj8yRdPcNiR7+FJG+RhElnMuXRgfG
         Tp13QKVYy0Cxw==
Received: from DireWolf ([108.49.206.201])
        by resomta-ch2-15v.sys.comcast.net with ESMTPSA
        id 1ErLiZurxy4OR1ErNiShpo; Fri, 23 Aug 2019 19:04:47 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgeduvddrudegkedgudeftdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfhfjgfufffkgggtgffothesthejghdtvddtvdenucfhrhhomhepfdfuthgvvhgvucgkrggsvghlvgdfuceoiigrsggvlhgvsegtohhmtggrshhtrdhnvghtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedutdekrdegledrvddtiedrvddtudenucfrrghrrghmpehhvghlohepffhirhgvhgholhhfpdhinhgvthepuddtkedrgeelrddvtdeirddvtddupdhmrghilhhfrhhomhepiigrsggvlhgvsegtohhmtggrshhtrdhnvghtpdhrtghpthhtohepuggrnhhivghlsehiohhgvggrrhgsohigrdhnvghtpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhnvdhkudeinhhmsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgrihhfihdrkhhhrghnsehsthhrihhkrhdrihhnpdhrtghpthhtohepshhhuhhmsegtrghnnhgurhgvfidrohhrghdprhgtphhtthhopehsthgvphhhvghnsehnvghtfihorhhkphhluhhmsggvrhdrohhrghdprhgtphhtthhopehvlhgrughimhhirhduudeisehgmhgrihhlrdgtohhmpdhrtghpthhtohepiigrsggvlhgvsegtohhmtggrshhtrdhnvghtnecuveh
X-Xfinity-VMeta: sc=-100;st=legit
From:   "Steve Zabele" <zabele@comcast.net>
To:     "'Steve Zabele'" <zabele@comcast.net>, <netdev@vger.kernel.org>
Cc:     <shum@canndrew.org>, <vladimir116@gmail.com>,
        <saifi.khan@strikr.in>, <daniel@iogearbox.net>,
        <on2k16nm@gmail.com>,
        "'Stephen Hemminger'" <stephen@networkplumber.org>
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan> 
In-Reply-To: 
Subject: RE: Is bug 200755 in anyone's queue??
Date:   Fri, 23 Aug 2019 15:04:14 -0400
Message-ID: <01dc01d559e5$9a3735b0$cea5a110$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdU73y8GSy5AAiuFQ++MzGJ5eXpFdweBSl7QAABF6GA=
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

Is there a way to find out where the SO_REUSEPORT bug reported a year ago in
August (and apparently has been a bug with kernels later than 4.4) is being
addressed?

The bug characteristics, simple standalone test code demonstrating the bug,
and an assessment of the likely location/cause of the bug within the kernel
are all described here

https://bugzilla.kernel.org/show_bug.cgi?id=200755

I'm really hoping this gets fixed so we can move forward on updating our
kernels/Ubuntu release from our aging 4.4/16.04 release

Thanks!

Steve



-----Original Message-----
From: Stephen Hemminger [mailto:stephen@networkplumber.org] 
Sent: Tuesday, July 16, 2019 10:03 AM
To: Steve Zabele
Cc: shum@canndrew.org; vladimir116@gmail.com; saifi.khan@DataSynergy.org;
saifi.khan@strikr.in; daniel@iogearbox.net; on2k16nm@gmail.com
Subject: Re: Is bug 200755 in anyone's queue??

On Tue, 16 Jul 2019 09:43:24 -0400
"Steve Zabele" <zabele@comcast.net> wrote:


> I came across bug report 200755 trying to figure out why some code I had
> provided to customers a while ago no longer works with the current Linux
> kernel. See
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=200755
> 
> I've verified that, as reported, 'connect' no longer works for UDP.
> Moreover, it appears it has been broken since the 4.5 kernel has been
> released. 
> 
>  
> 
> It does also appear that the intended new feature of doing round robin
> assignments to different UDP sockets opened with SO_REUSEPORT also does
not
> work as described.
> 
>  
> 
> Since the original bug report was made nearly a year ago for the 4.14
kernel
> (and the bug is also still present in the 4.15 kernel) I'm curious if
anyone
> is on the hook to get this fixed any time soon.
> 
>  
> 
> I'd rather not have to do my own demultiplexing using a single socket in
> user space to work around what is clearly a (maybe not so recently
> introduced) kernel bug if at all possible. My code had worked just fine on
> 3.X kernels, and appears to work okay up through 4.4. 
> 

Kernel developers do not use bugzilla, I forward bug reports
to netdev@vger.kernel.org (after filtering).

