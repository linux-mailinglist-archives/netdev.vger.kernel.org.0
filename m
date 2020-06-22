Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DDA203252
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgFVIqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:46:04 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:36212 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgFVIqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 04:46:04 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2020 04:46:03 EDT
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 4TpWVnbtiqhHqTm8UcF3OpAb2ZHi7hzxMchVDlx84oPPC2OsOAjK2SGuA51o1ODupl2ywABbKs
 sTGTZwEKCHOWRk3j67f09FvjcIBqouRt4xz0ohd5suQxkDHg1yk+MHmJxOxAluIGqpnqFIF2OH
 04YAJ30lc/a5kSPPrGakF2TBnKOjBMH1fUOJ6TzqIMxiVO3Q14HqKHl9cdBd1jOqInig3Z6IN1
 SRgzwpiMw315v8aBPVr76xaemjJo64jKEZKyF3QQUDhxS0lx2+OvdOzT0m389dE4n5hBxoFbH/
 0mM=
X-SBRS: 2.7
X-MesageID: 20942116
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,266,1589256000"; 
   d="scan'208";a="20942116"
Date:   Mon, 22 Jun 2020 10:38:46 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and
 hibernation]
Message-ID: <20200622083846.GF735@Air-de-Roger>
References: <7FD7505E-79AA-43F6-8D5F-7A2567F333AB@amazon.com>
 <20200604070548.GH1195@Air-de-Roger>
 <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200617083528.GW735@Air-de-Roger>
 <20200619234312.GA24846@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619234312.GA24846@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:43:12PM +0000, Anchal Agarwal wrote:
> On Wed, Jun 17, 2020 at 10:35:28AM +0200, Roger Pau Monné wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Tue, Jun 16, 2020 at 09:49:25PM +0000, Anchal Agarwal wrote:
> > > On Thu, Jun 04, 2020 at 09:05:48AM +0200, Roger Pau Monné wrote:
> > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > On Wed, Jun 03, 2020 at 11:33:52PM +0000, Agarwal, Anchal wrote:
> > > > >  CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > >     > +             xenbus_dev_error(dev, err, "Freezing timed out;"
> > > > >     > +                              "the device may become inconsistent state");
> > > > >
> > > > >     Leaving the device in this state is quite bad, as it's in a closed
> > > > >     state and with the queues frozen. You should make an attempt to
> > > > >     restore things to a working state.
> > > > >
> > > > > You mean if backend closed after timeout? Is there a way to know that? I understand it's not good to
> > > > > leave it in this state however, I am still trying to find if there is a good way to know if backend is still connected after timeout.
> > > > > Hence the message " the device may become inconsistent state".  I didn't see a timeout not even once on my end so that's why
> > > > > I may be looking for an alternate perspective here. may be need to thaw everything back intentionally is one thing I could think of.
> > > >
> > > > You can manually force this state, and then check that it will behave
> > > > correctly. I would expect that on a failure to disconnect from the
> > > > backend you should switch the frontend to the 'Init' state in order to
> > > > try to reconnect to the backend when possible.
> > > >
> > > From what I understand forcing manually is, failing the freeze without
> > > disconnect and try to revive the connection by unfreezing the
> > > queues->reconnecting to backend [which never got diconnected]. May be even
> > > tearing down things manually because I am not sure what state will frontend
> > > see if backend fails to to disconnect at any point in time. I assumed connected.
> > > Then again if its "CONNECTED" I may not need to tear down everything and start
> > > from Initialising state because that may not work.
> > >
> > > So I am not so sure about backend's state so much, lets say if  xen_blkif_disconnect fail,
> > > I don't see it getting handled in the backend then what will be backend's state?
> > > Will it still switch xenbus state to 'Closed'? If not what will frontend see,
> > > if it tries to read backend's state through xenbus_read_driver_state ?
> > >
> > > So the flow be like:
> > > Front end marks XenbusStateClosing
> > > Backend marks its state as XenbusStateClosing
> > >     Frontend marks XenbusStateClosed
> > >     Backend disconnects calls xen_blkif_disconnect
> > >        Backend fails to disconnect, the above function returns EBUSY
> > >        What will be state of backend here?
> > 
> > Backend should stay in state 'Closing' then, until it can finish
> > tearing down.
> > 
> It disconnects the ring after switching to connected state too. 
> > >        Frontend did not tear down the rings if backend does not switches the
> > >        state to 'Closed' in case of failure.
> > >
> > > If backend stays in CONNECTED state, then even if we mark it Initialised in frontend, backend
> > 
> > Backend will stay in state 'Closing' I think.
> > 
> > > won't be calling connect(). {From reading code in frontend_changed}
> > > IMU, Initialising will fail since backend dev->state != XenbusStateClosed plus
> > > we did not tear down anything so calling talk_to_blkback may not be needed
> > >
> > > Does that sound correct?
> > 
> > I think switching to the initial state in order to try to attempt a
> > reconnection would be our best bet here.
> >
> It does not seems to work correctly, I get hung tasks all over and all the
> requests to filesystem gets stuck. Backend does shows the state as connected
> after xenbus_dev_suspend fails but I think there may be something missing.
> I don't seem to get IO interrupts thereafter i.e hitting the function blkif_interrupts.
> I think just marking it initialised may not be the only thing.
> Here is a short description of what I am trying to do:
> So, on timeout:
>     Switch XenBusState to "Initialized"
>     unquiesce/unfreeze the queues and return
>     mark info->connected = BLKIF_STATE_CONNECTED

If xenbus state is Initialized isn't it wrong to set info->connected
== CONNECTED?

You should tear down all the internal state (like a proper close)?

>     return EBUSY
> 
> I even allowed blkfront_connect to switch state to "CONNECTED" rather me doing
> it explicitly as mentioned above without re-allocating/re-registering the device
> just to make sure bklfront_info object has all the right values.
> Do you see anythign missing here?

I'm afraid you will have to do a little bit of debugging here to
figure out what's going on. You can add printk's to several places to
see which path is taken, and why blkfront ends in such state.

Thanks, Roger.
